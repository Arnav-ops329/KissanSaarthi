import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onnxruntime_v2/onnxruntime_v2.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'disease_api_service.dart';
import 'disease_solutions_service.dart';

class YoloOfflineService {
  static OrtSession? _session;
  static List<String>? _labels;
  static bool _envInitialized = false;
  static String? _initError;

  static const int modelInputSize = 640;

  static Future<void> init() async {
    if (_session != null) return;
    _initError = null;

    try {
      // Initialize ONNX Runtime Environment (Only Once)
      if (!_envInitialized) {
        debugPrint("YOLO: Initializing OrtEnv...");
        OrtEnv.instance.init();
        _envInitialized = true;
      }

      // Load Model from Assets and Copy to Local File
      debugPrint("YOLO: Loading model from assets/models/best.onnx...");
      final ByteData modelData =
          await rootBundle.load('assets/models/best.onnx');

      final Directory docDir = await getApplicationSupportDirectory();
      final File modelFile = File('${docDir.path}/best.onnx');

      if (!await modelFile.exists() ||
          (await modelFile.length()) != modelData.lengthInBytes) {
        debugPrint("YOLO: Writing model to disk at ${modelFile.path}...");
        await modelFile.writeAsBytes(
          modelData.buffer
              .asUint8List(modelData.offsetInBytes, modelData.lengthInBytes),
          flush: true,
        );
      }

      debugPrint("YOLO: Model ready, size: ${modelFile.lengthSync()} bytes");

      final sessionOptions = OrtSessionOptions();

      _session = OrtSession.fromFile(modelFile, sessionOptions);
      debugPrint("YOLO: Session created successfully.");

      // Load Labels
      debugPrint("YOLO: Loading labels from assets/models/labels.txt...");
      final String labelsData =
          await rootBundle.loadString('assets/models/labels.txt');
      // Keep underscores for internal class splitting logic
      _labels = labelsData
          .split('\n')
          .where((s) => s.isNotEmpty)
          .map((s) => s.trim())
          .toList();
      debugPrint("YOLO: Labels loaded: ${_labels?.length} classes.");
    } catch (e, stack) {
      _initError = "$e\n$stack";
      debugPrint("YOLO Init Error: $e");
    }
  }

  static Future<Map<String, dynamic>> detectDisease(String imagePath) async {
    await init();

    if (_session == null || _labels == null) {
      debugPrint("YOLO Init failed. Trying Online API...");
      try {
        return await DiseaseApiService.detectDisease(imagePath);
      } catch (e) {
        return {
          "disease": "Error",
          "crop": "Offline",
          "confidence": "0",
          "solution":
              "Model failed to load and No Internet available. Error: ${_initError ?? 'Unknown'}"
        };
      }
    }

    try {
      // 1. Load and Preprocess Image
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        return {
          "disease": "Error",
          "confidence": "0",
          "solution": "Invalid image format"
        };
      }

      // Resize to 640x640
      img.Image resizedImage =
          img.copyResize(image, width: modelInputSize, height: modelInputSize);

      // 2. Convert to Tensor Format [1, 3, 640, 640] - Planar (CHW)
      final Float32List input =
          Float32List(1 * 3 * modelInputSize * modelInputSize);

      for (int y = 0; y < modelInputSize; y++) {
        for (int x = 0; x < modelInputSize; x++) {
          final pixel = resizedImage.getPixel(x, y);
          input[y * modelInputSize + x] = pixel.r / 255.0; // Red plane
          input[modelInputSize * modelInputSize + y * modelInputSize + x] =
              pixel.g / 255.0; // Green plane
          input[2 * modelInputSize * modelInputSize + y * modelInputSize + x] =
              pixel.b / 255.0; // Blue plane
        }
      }

      final shape = [1, 3, modelInputSize, modelInputSize];
      final inputTensor = OrtValueTensor.createTensorWithDataList(input, shape);

      // 3. Run Inference
      final inputs = {'images': inputTensor};
      final runOptions = OrtRunOptions();
      final outputs = _session!.run(runOptions, inputs);

      inputTensor.release();
      runOptions.release();

      if (outputs.isEmpty) {
        return await DiseaseApiService.detectDisease(imagePath);
      }

      // 4. Post-processing
      final firstOutput = outputs[0];
      final outputValue = firstOutput?.value;

      if (firstOutput == null || outputValue == null || outputValue is! List) {
        debugPrint("YOLO unexpected format. Trying Online API...");
        return await DiseaseApiService.detectDisease(imagePath);
      }

      final results = _parseYoloOutput(outputValue[0], _labels!);

      for (var element in outputs) {
        element?.release();
      }

      if (results.isEmpty) {
        debugPrint("YOLO found no results. Trying Online API...");
        try {
          final onlineResult = await DiseaseApiService.detectDisease(imagePath);
          return onlineResult;
        } catch (e) {
          return {
            "disease": "Healthy / No Disease Detected",
            "crop": "General",
            "confidence": "0",
            "solution":
                "The offline model found no diseases, and online analysis is unavailable."
          };
        }
      }

      // Return the best result
      final best = results[0];
      final String rawLabel = best['label'] as String;

      // Parse crop and disease names
      String cropName = "Crop";
      String diseaseName = rawLabel.replaceAll('_', ' ');

      if (rawLabel.contains('_')) {
        final parts = rawLabel.split('_');
        cropName = parts[0];
      }

      return {
        "disease": diseaseName,
        "crop": cropName[0].toUpperCase() + cropName.substring(1).toLowerCase(),
        "confidence": (best['score'] * 100).toStringAsFixed(1),
        "solution": DiseaseSolutionsService.getSolution(rawLabel)
      };
    } catch (e) {
      debugPrint("YOLO Inference Error: $e. Falling back to Online API...");
      try {
        return await DiseaseApiService.detectDisease(imagePath);
      } catch (onlineError) {
        return {
          "disease": "Error",
          "confidence": "0",
          "solution": "Detection failed (Offline: $e, Online: $onlineError)"
        };
      }
    }
  }

  static List<Map<String, dynamic>> _parseYoloOutput(
      dynamic output, List<String> labels) {
    if (output is! List || output.isEmpty) return [];

    // YOLOv11/v8 format can be [34, 8400] or [8400, 34] (transposed)
    // where 34 = 4 (coords) + numClasses (30)
    int dim1 = output.length;
    int dim2 = (output[0] is List) ? (output[0] as List).length : -1;

    int numClasses = labels.length;
    List<Map<String, dynamic>> detections = [];

    // CASE 1: [34, 8400]
    if (dim1 == numClasses + 4) {
      int numAnchors = dim2;
      for (int i = 0; i < numAnchors; i++) {
        double maxScore = 0;
        int classId = -1;
        for (int c = 0; c < numClasses; c++) {
          final scoreVal = output[4 + c][i];
          double score = (scoreVal is num) ? scoreVal.toDouble() : 0.0;
          if (score > maxScore) {
            maxScore = score;
            classId = c;
          }
        }
        if (maxScore > 0.15) {
          // Lowered further for debugging
          detections.add({
            'label': labels[classId],
            'score': maxScore,
          });
        }
      }
    }
    // CASE 2: [8400, 34]
    else if (dim2 == numClasses + 4) {
      int numAnchors = dim1;
      for (int i = 0; i < numAnchors; i++) {
        double maxScore = 0;
        int classId = -1;
        for (int c = 0; c < numClasses; c++) {
          final scoreVal = output[i][4 + c];
          double score = (scoreVal is num) ? scoreVal.toDouble() : 0.0;
          if (score > maxScore) {
            maxScore = score;
            classId = c;
          }
        }
        if (maxScore > 0.15) {
          detections.add({
            'label': labels[classId],
            'score': maxScore,
          });
        }
      }
    } else {
      debugPrint(
          "YOLO: Unknown output shape [1, $dim1, $dim2]. Expecting index 34 at dim1 or dim2.");
    }

    detections
        .sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));
    return detections;
  }
}
