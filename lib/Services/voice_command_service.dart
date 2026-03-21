class VoiceCommandService {
  static bool _matches(String text, List<String> keywords) {
    for (var word in keywords) {
      if (RegExp("\\b$word\\b", caseSensitive: false).hasMatch(text)) {
        return true;
      }
    }
    return false;
  }

  static Map<String, String> processCommand(String text) {
    text = text.toLowerCase().trim();

    // 🎙️ 1. Weather (High Priority)
    if (_matches(text, [
      "weather",
      "mausam",
      "mousam",
      "forecast",
      "temperature",
      "ba بارش",
      "bijli",
      "climate",
      "rain",
      "sun",
      "cloud"
    ])) {
      return {
        "route": "/weather",
        "response": "Opening weather reports.",
        "flow": "weatherQuery",
      };
    }

    // 🎙️ 2. Real-Time Scan
    if (_matches(text, [
      "scan",
      "scanner",
      "camera",
      "capture",
      "bimari",
      "pest",
      "detect",
      "identify",
      "disease",
      "photo"
    ])) {
      return {
        "route": "/scanner",
        "response": "Opening real-time crop scanner.",
        "flow": "cropScan",
      };
    }

    // 🎙️ 3. Static Upload / Gallery
    if (_matches(text, [
       "upload", "gallery", "choose", "picture", "image", "file"
    ])) {
      return {
        "route": "/upload",
        "response": "Opening image upload.",
        "flow": "cropScan",
      };
    }

    // 🎙️ 4. Mandi Prices
    if (_matches(
        text, ["mandi", "price", "market", "daam", "bhav", "rates", "sell", "buy", "cost"])) {
      String? found;
      final crops = ["wheat", "rice", "potato", "tomato", "cotton", "corn", "soybean"];
      for (var c in crops) {
        if (text.contains(c)) {
          found = c;
          break;
        }
      }
      return {
        "route": "/market",
        "response": found != null
            ? "Checking $found prices."
            : "Opening Mandi prices.",
        "flow": "mandiPrice",
        "crop": found ?? "",
      };
    }

    // 🎙️ 5. Fertilizer
    if (_matches(text, [
      "fertilizer",
      "khad",
      "calculate",
      "calculation",
      "urea",
      "dap",
      "nutrition",
      "npk",
      "compost"
    ])) {
      return {
        "route": "/fertilizer",
        "response": "Opening fertilizer calculator.",
        "flow": "fertilizer",
      };
    }

    // 🎙️ 6. Crop Suggestion / Recommendation
    if (_matches(
        text, ["crop", "recommend", "suggest", "advice", "fasal", "grow", "plant", "season", "soil"])) {
      return {
        "route": "/crop_recommend",
        "response": "Opening crop recommendations.",
        "flow": "cropRecommend",
      };
    }

    // 🎙️ 7. Government Schemes
    if (_matches(text, ["scheme", "yojana", "government", "sarkar", "subsidy", "loan"])) {
      return {
        "route": "/schemes",
        "response": "Opening government schemes.",
      };
    }

    // 🎙️ 8. Language Screen
    if (_matches(text, ["language", "bhasha", "english", "hindi", "marathi", "tamil", "bengali", "translate", "change"])) {
      return {
        "route": "/language",
        "response": "Opening language settings.",
      };
    }

    // 🎙️ 9. Home Screen
    if (_matches(text, ["home", "dashboard", "main", "back", "shuru", "start", "menu"])) {
      return {
        "route": "/home",
        "response": "Going to home screen.",
      };
    }

    // 🎙️ 10. Wake Word / AI Chat
    if (_matches(text, [
      "chat",
      "ai",
      "bot",
      "assistant",
      "talk",
      "ask",
      "question",
      "help",
      "hey kisan",
      "hey kishan",
      "hi kisan",
      "digital agronomist",
      "sahayak"
    ])) {
      return {
        "route": "/chat",
        "response": "I am here to help you. Opening AI Assistant.",
      };
    }

    return {
      "route": "",
      "response":
          "Sorry, I did not understand. Try saying 'Mandi price', 'Scan crop', or 'Open weather'.",
    };
  }
}
