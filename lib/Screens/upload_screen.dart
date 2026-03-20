import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/disease_api_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool loading = false;

  final picker = ImagePicker();

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    detectDisease(picked.path);
  }

  Future detectDisease(String path) async {
    setState(() {
      loading = true;
    });

    var result = await DiseaseApiService.detectDisease(path);

    setState(() {
      loading = false;
    });

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
