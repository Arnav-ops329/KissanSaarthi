import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/yolo_offline_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool loading = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Warm up the model
    YoloOfflineService.init();
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    await detectDisease(picked.path);
  }

  Future<void> detectDisease(String path) async {
    setState(() {
      loading = true;
    });

    // 🚀 USE OFFLINE YOLO MODEL
    final result = await YoloOfflineService.detectDisease(path);

    setState(() {
      loading = false;
    });

    if (!mounted) return;
    Navigator.pushNamed(
      context,
      '/result',
      arguments: result,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Crop Image"),
      ),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: pickImage,
                child: const Text("Select Image"),
              ),
      ),
    );
  }
}
