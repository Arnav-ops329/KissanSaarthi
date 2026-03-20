import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../services/ai_service.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  SpeechToText speech = SpeechToText();

  String text = "Tap mic to speak";
  String aiResponse = "";
  bool isListening = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Auto-start listening when screen opens
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) startListening();
    });
  }

  void startListening() async {
    bool available = await speech.initialize(
      onStatus: (status) {
        if (mounted) {
          setState(() => isListening = (status == 'listening'));
        }
      },
      onError: (e) {
        debugPrint("Speech Error: $e");
        if (mounted) setState(() => isListening = false);
      }
    );

    if (available) {
      if (mounted) setState(() => isListening = true);
      speech.listen(
        onResult: (result) async {
          if (mounted) {
            setState(() {
              text = result.recognizedWords;
            });
            if (result.finalResult) {
              await getAIResponse(result.recognizedWords);
            }
          }
        },
      );
    }
  }

  Future<void> getAIResponse(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      isLoading = true;
    });

    final resp = await AIService.getAIResponse(query);

    if (mounted) {
      setState(() {
        aiResponse = resp;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Farming Assistant"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.psychology, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black54, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 40),
            if (isLoading)
              const CircularProgressIndicator(color: Colors.green)
            else if (aiResponse.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withAlpha(51)),
                ),
                child: Text(
                  aiResponse,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.w600, 
                    color: Color(0xFF1B5E20)
                  ),
                ),
              ),
            const SizedBox(height: 60),
            FloatingActionButton.large(
              onPressed: isListening ? null : startListening,
              backgroundColor: isListening ? Colors.red : Colors.green,
              elevation: 4,
              child: Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              isListening ? "Listening..." : "Tap to Ask AI", 
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)
            ),
          ],
        ),
      ),
    );
  }
}
