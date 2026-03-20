import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class ScannerScreen extends StatefulWidget {
  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future initializeCamera() async {
    final cameras = await availableCameras();

    controller = CameraController(cameras[0], ResolutionPreset.medium);

    await controller?.initialize();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Live Crop Scanner")),

      body: CameraPreview(controller!),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera),
        onPressed: captureImage,
      ),
    );
  }

  void captureImage() {
    // send frame to AI model

    print("Scanning crop");
  }
}
