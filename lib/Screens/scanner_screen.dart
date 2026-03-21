import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../localization/app_localizations.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();

    controller = CameraController(cameras[0], ResolutionPreset.medium);

    await controller?.initialize();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.loc('scan_crop'))),

      body: CameraPreview(controller!),

      floatingActionButton: FloatingActionButton(
        onPressed: captureImage,
        child: const Icon(Icons.camera),
      ),
    );
  }

  void captureImage() {
    // send frame to AI model
  }
}
