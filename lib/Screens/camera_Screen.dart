import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../services/yolo_offline_service.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late List<CameraDescription> cameras;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    initCamera();
    YoloOfflineService.init();
  }

  Future initCamera() async {
    cameras = await availableCameras();

    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );

    await controller.initialize();

    setState(() {});
  }

  Future<void> captureImage() async {
    if (isDetecting) return;

    setState(() {
      isDetecting = true;
    });

    try {
      final image = await controller.takePicture();

      if (!mounted) return;

      // 🚀 USE OFFLINE YOLO MODEL
      final result = await YoloOfflineService.detectDisease(image.path);

      if (!mounted) return;
      Navigator.pushNamed(
        context,
        '/result',
        arguments: result,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isDetecting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Scanner"),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          /// 📸 CAMERA PREVIEW (FIXED RENDERING)
          Positioned.fill(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),

          /// 🔲 SCAN BOX (optional but cool)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green, width: 3),
              ),
            ),
          ),

          /// 📷 CAPTURE BUTTON
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: captureImage,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text("Capture Crop"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
