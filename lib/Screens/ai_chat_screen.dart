import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AIChatScreen extends StatefulWidget {
  @override
  _AIChatScreenState createState() => _AIChatScreenState();
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
      appBar: AppBar(title: Text("AI Farming Assistant")),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(text, style: TextStyle(fontSize: 20)),

          SizedBox(height: 20),

          FloatingActionButton(
            child: Icon(Icons.mic),
            onPressed: startListening,
          ),
        ],
      ),
    );
  }
}
