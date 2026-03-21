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
  static const int modelInputSize = 640;

  static Future<void> init() async {
    if (_session != null) return;
    try {
      if (!_envInitialized) {
        OrtEnv.instance.init();
        _envInitialized = true;
      }
      final ByteData modelData = await rootBundle.load('assets/models/best.onnx');
      final Directory docDir = await getApplicationSupportDirectory();
      final File modelFile = File('${docDir.path}/best.onnx');
      if (!await modelFile.exists() || (await modelFile.length()) != modelData.lengthInBytes) {
        await modelFile.writeAsBytes(modelData.buffer.asUint8List(modelData.offsetInBytes, modelData.lengthInBytes), flush: true);
      }
      _session = OrtSession.fromFile(modelFile, OrtSessionOptions());
      final String labelsData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData.split('\n').where((s) => s.isNotEmpty).map((s) => s.trim()).toList();
    } catch (e) {
      debugPrint("YOLO Init Error: $e");
    }
  }

  static Future<Map<String, dynamic>> detectDisease(String imagePath) async {
    await init();
    if (_session == null || _labels == null) {
      return await DiseaseApiService.detectDisease(imagePath);
    }
    try {
      final bytes = await File(imagePath).readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        return {"disease": "Error", "confidence": "0", "solution": "Invalid format"};
      }
      img.Image resImg = img.copyResize(image, width: modelInputSize, height: modelInputSize);
      final Float32List input = Float32List(1 * 3 * modelInputSize * modelInputSize);
      for (int y = 0; y < modelInputSize; y++) {
        for (int x = 0; x < modelInputSize; x++) {
          final pixel = resImg.getPixel(x, y);
          input[y * modelInputSize + x] = pixel.r / 255.0;
          input[modelInputSize * modelInputSize + y * modelInputSize + x] = pixel.g / 255.0;
          input[2 * modelInputSize * modelInputSize + y * modelInputSize + x] = pixel.b / 255.0;
        }
      }
      final inTensor = OrtValueTensor.createTensorWithDataList(input, [1, 3, modelInputSize, modelInputSize]);
      final outputs = _session!.run(OrtRunOptions(), {'images': inTensor});
      inTensor.release();
      if (outputs.isEmpty) {
        return await DiseaseApiService.detectDisease(imagePath);
      }
      final rawOut = outputs[0]?.value;
      if (rawOut == null || rawOut is! List || rawOut.isEmpty) {
        return await DiseaseApiService.detectDisease(imagePath);
      }
      final results = _parseYoloOutput(rawOut[0], _labels!);
      for (var element in outputs) {
        element?.release();
      }
      if (results.isEmpty) {
        return await DiseaseApiService.detectDisease(imagePath);
      }
      final best = results[0];
      final String rawLabel = best['label'] as String;
      String cropName = rawLabel.contains('_') ? rawLabel.split('_')[0] : "Crop";
      return {
        "disease": rawLabel.replaceAll('_', ' '),
        "crop": cropName[0].toUpperCase() + cropName.substring(1).toLowerCase(),
        "confidence": (best['score'] * 100).toStringAsFixed(1), "score": best['score'], "box": best['box'],
        "solution": DiseaseSolutionsService.getSolution(rawLabel)
      };
    } catch (e) { return await DiseaseApiService.detectDisease(imagePath); }
  }

  static List<Map<String, dynamic>> _parseYoloOutput(dynamic output, List<String> labels) {
    if (output is! List || output.isEmpty) return [];
    int dim1 = output.length, dim2 = (output[0] is List) ? (output[0] as List).length : -1, numCls = labels.length;
    List<Map<String, dynamic>> detections = [];
    if (dim1 == numCls + 4) {
      for (int i = 0; i < dim2; i++) {
        double maxS = 0; int clsId = -1;
        for (int c = 0; c < numCls; c++) {
          final s = (output[4 + c][i] is num) ? output[4 + c][i].toDouble() : 0.0;
          if (s > maxS) { maxS = s; clsId = c; }
        }
        if (maxS > 0.15) {
          final double cx = output[0][i].toDouble(), cy = output[1][i].toDouble(), w = output[2][i].toDouble(), h = output[3][i].toDouble();
          detections.add({'label': labels[clsId], 'score': maxS, 'box': [cx - w / 2, cy - h / 2, w, h]});
        }
      }
    } else if (dim2 == numCls + 4) {
      for (int i = 0; i < dim1; i++) {
        double maxS = 0; int clsId = -1;
        for (int c = 0; c < numCls; c++) {
          final s = (output[i][4 + c] is num) ? output[i][4 + c].toDouble() : 0.0;
          if (s > maxS) { maxS = s; clsId = c; }
        }
        if (maxS > 0.15) {
          final double cx = output[i][0].toDouble(), cy = output[i][1].toDouble(), w = output[i][2].toDouble(), h = output[i][3].toDouble();
          detections.add({'label': labels[clsId], 'score': maxS, 'box': [cx - w / 2, cy - h / 2, w, h]});
        }
      }
    }
    detections.sort((a,b) => (b['score'] as double).compareTo(a['score'] as double));
    return detections;
  }

  static Future<List<Map<String, dynamic>>> detectRealTime(img.Image image) async {
    await init();
    if (_session == null || _labels == null) return [];
    try {
      img.Image resImg = img.copyResize(image, width: modelInputSize, height: modelInputSize);
      final Float32List input = Float32List(1 * 3 * modelInputSize * modelInputSize);
      for (int y = 0; y < modelInputSize; y++) {
        for (int x = 0; x < modelInputSize; x++) {
          final pixel = resImg.getPixel(x, y);
          input[y * modelInputSize + x] = pixel.r / 255.0;
          input[modelInputSize * modelInputSize + y * modelInputSize + x] = pixel.g / 255.0;
          input[2 * modelInputSize * modelInputSize + y * modelInputSize + x] = pixel.b / 255.0;
        }
      }
      final inTensor = OrtValueTensor.createTensorWithDataList(input, [1, 3, modelInputSize, modelInputSize]);
      final outputs = _session!.run(OrtRunOptions(), {'images': inTensor});
      inTensor.release();
      if (outputs.isEmpty) return [];
      final firstOut = outputs[0];
      final rawOut = firstOut?.value;
      if (rawOut == null || rawOut is! List || rawOut.isEmpty) return [];
      final res = _parseYoloOutput(rawOut[0], _labels!);
      for (var element in outputs) {
        element?.release();
      }
      return res.map((r) {
        final String rawLabel = r['label'] as String;
        String cropName = rawLabel.contains('_') ? rawLabel.split('_')[0] : "Crop";
        return {
          "label": rawLabel.replaceAll('_', ' '),
          "crop": cropName[0].toUpperCase() + cropName.substring(1).toLowerCase(),
          "confidence": (r['score'] * 100).toStringAsFixed(1),
          "score": r['score'], "box": r['box'], "rawLabel": rawLabel,
        };
      }).toList();
    } catch (e) { return []; }
  }
}
