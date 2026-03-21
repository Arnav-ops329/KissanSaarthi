import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../providers/voice_flow_provider.dart';
import '../Services/voice_command_service.dart';

class GlobalVoiceButton extends StatefulWidget {
  final VoidCallback? onCommandProcessed;
  const GlobalVoiceButton({super.key, this.onCommandProcessed});

  @override
  State<GlobalVoiceButton> createState() => _GlobalVoiceButtonState();
}

class _GlobalVoiceButtonState extends State<GlobalVoiceButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool isListening = false;
  double _voiceLevel = 0.0;

  void _listen() async {
    final voiceFlow = Provider.of<VoiceFlowProvider>(context, listen: false);
    
    if (!isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'done' || val == 'notListening') {
            setState(() => isListening = false);
          }
        },
        onError: (val) => setState(() => isListening = false),
      );

      if (available) {
        setState(() => isListening = true);
        _speech.listen(
          onSoundLevelChange: (val) => setState(() => _voiceLevel = val),
          onResult: (result) async {
            String text = result.recognizedWords.toLowerCase();
            if (text.isNotEmpty) {
              if (voiceFlow.handleInput(text, context)) {
                _speech.stop();
                setState(() => isListening = false);
                if (widget.onCommandProcessed != null) widget.onCommandProcessed!();
                return;
              }

              // If not handled by specific flow, try general commands
              final action = VoiceCommandService.processCommand(text);
              final String route = action["route"] ?? "";
              
              if (route.isNotEmpty) {
                final appP = Provider.of<AppProvider>(context, listen: false);
                _speech.stop();
                setState(() => isListening = false);
                
                final String response = action["response"] ?? "";
                if (response.isNotEmpty) {
                  await voiceFlow.speak(response);
                }
                
                if (!mounted) return;

                // Sync with VoiceFlowProvider
                final flow = action["flow"] ?? "";
                if (flow == "fertilizer") {
                  voiceFlow.startFertilizerFlow();
                } else if (flow == "mandiPrice") {
                  voiceFlow.startMandiFlow(initialCrop: action["crop"]);
                } else if (flow == "weatherQuery") {
                  voiceFlow.startWeatherFlow(appP.weatherData, appP.userCity);
                } else if (flow == "cropScan") {
                  voiceFlow.startCropScanFlow();
                } else if (flow == "cropRecommend") {
                  voiceFlow.startCropRecommendFlow();
                }

                Navigator.pushNamed(context, route);
                if (widget.onCommandProcessed != null) widget.onCommandProcessed!();
              } else if (result.finalResult) {
                // Unrecognized command at the end of speaking
                _speech.stop();
                setState(() => isListening = false);
                final String response = action["response"] ?? "Sorry, I didn't catch that.";
                await voiceFlow.speak(response);
                if (widget.onCommandProcessed != null) widget.onCommandProcessed!();
              }
            }
          },
        );
      }
    } else {
      setState(() => isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isListening)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(color: const Color(0xFF2E7D32), borderRadius: BorderRadius.circular(20)),
            child: const Text("Listening...", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        GestureDetector(
          onTap: _listen,
          child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: isListening ? Colors.red : const Color(0xFF2E7D32),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (isListening ? Colors.red : const Color(0xFF2E7D32)).withAlpha(80),
                  blurRadius: isListening ? 20 + (_voiceLevel * 2) : 10,
                  spreadRadius: isListening ? 5 : 0,
                )
              ],
            ),
            child: Icon(isListening ? Icons.stop : Icons.mic, color: Colors.white, size: 35),
          ),
        ),
      ],
    );
  }
}
