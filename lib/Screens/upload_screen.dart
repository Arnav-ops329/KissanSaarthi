import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/yolo_offline_service.dart';
import '../providers/voice_flow_provider.dart';
import '../Widgets/global_voice_button.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  bool _isAnalyzing = false;
  String? _imagePath;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null && mounted) {
      _detectDisease(pickedFile.path);
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    YoloOfflineService.init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    if (!_isAnalyzing) {
      if (args is String) {
        _imagePath = args;
        _detectDisease(args);
      } else if (args == null) {
        _isAnalyzing = true;
        Future.microtask(() => _pickImage());
      }
    }
  }

  Future<void> _detectDisease(String path) async {
    setState(() => _isAnalyzing = true);
    final result = await YoloOfflineService.detectDisease(path);
    if (!mounted) return;
    
    // Stop flow if it was a guided scan
    final voiceFlow = Provider.of<VoiceFlowProvider>(context, listen: false);
    if (voiceFlow.activeFlow == VoiceFlow.cropScan) {
      voiceFlow.stopFlow();
      voiceFlow.speak("Diagnosis complete. I've found ${result['disease']}. Check your screen for solutions.");
    }

    Navigator.pushReplacementNamed(context, '/result', arguments: result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text("KisaanSaarthi AI"),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.green, strokeWidth: 6),
            const SizedBox(height: 32),
            const Text(
              "AI is analyzing your crop...",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Identify diseases instantly using offline models.",
              style: TextStyle(color: Colors.grey),
            ),
            if (_imagePath != null) ...[
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
      floatingActionButton: const GlobalVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
