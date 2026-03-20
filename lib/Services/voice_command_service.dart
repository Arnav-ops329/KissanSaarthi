class VoiceCommandService {
  static Map<String, String> processCommand(String text) {
    text = text.toLowerCase().trim();

    // 🎙️ Direct Keywords (No Wake Word Required)
    if (text.contains("weather") || text.contains("mausam") || text.contains("mousam")) {
      return {
        "route": "/weather",
        "response": "Opening weather reports.",
        "flow": "weatherQuery",
      };
    }

    if (text.contains("mandi") || text.contains("price") || text.contains("market") || text.contains("daam") || text.contains("bhav")) {
      String? found;
      final crops = ["wheat", "rice", "potato", "tomato", "cotton"];
      for (var c in crops) {
        if (text.contains(c)) {
          found = c;
          break;
        }
      }
      return {
        "route": "/market",
        "response": found != null ? "Checking $found prices." : "Opening Mandi prices.",
        "flow": "mandiPrice",
        "crop": found ?? "",
      };
    }

    if (text.contains("scan") || text.contains("upload") || text.contains("photo") || text.contains("bimari")) {
      return {
        "route": "/upload",
        "response": "Opening crop scanner.",
        "flow": "cropScan",
      };
    }

    if (text.contains("fertilizer") || text.contains("khad") || text.contains("calculate")) {
      return {
        "route": "/fertilizer",
        "response": "Opening fertilizer calculator.",
        "flow": "fertilizer",
      };
    }

    if (text.contains("crop") || text.contains("recommend") || text.contains("suggest") || text.contains("advice") || text.contains("fasal")) {
      return {
        "route": "/crop_recommend",
        "response": "Opening crop recommendations.",
        "flow": "cropRecommend",
      };
    }

    if (text.contains("scheme") || text.contains("yojana") || text.contains("government")) {
      return {
        "route": "/schemes",
        "response": "Opening government schemes.",
      };
    }

    // 🎙️ Wake Word Fallback: "Hey Kisan" (for general AI conversation)
    final wakeWords = [
      "hey kisan",
      "hey kishan",
      "hey kissan",
      "hi kisan",
      "hey kisan ji",
      "hey kisaan",
      "kisan kisan",
      "kissan kissan"
    ];
    
    bool hasWakeWord = wakeWords.any((word) => text.contains(word));
    if (hasWakeWord) {
      return {
        "route": "/chat",
        "response": "I am here to help you. Opening AI Assistant.",
      };
    }

    return {
      "route": "",
      "response": "Sorry, I did not understand. Try saying 'Mandi price' or 'Weather'.",
    };
  }
}
