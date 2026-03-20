import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({super.key});

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  SpeechToText speech = SpeechToText();

  String text = "Tap mic to speak";

  void startListening() async {
    await speech.initialize();

    speech.listen(
      onResult: (result) {
        setState(() {
          text = result.recognizedWords;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Farming Assistant")),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(text, style: const TextStyle(fontSize: 20)),

          const SizedBox(height: 20),

          FloatingActionButton(
            onPressed: startListening,
            child: const Icon(Icons.mic),
          ),
        ],
      ),
    );
  }
}
