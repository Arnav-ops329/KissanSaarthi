import 'package:speech_to_text/speech_to_text.dart';

class VoiceService {
  final SpeechToText speech = SpeechToText();

  Future startListening(Function(String) onResult) async {
    bool available = await speech.initialize();

    if (available) {
      speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
  }
}
