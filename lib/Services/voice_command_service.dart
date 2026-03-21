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
      "bijli"
    ])) {
      return {
        "route": "/weather",
        "response": "Opening weather reports.",
        "flow": "weatherQuery",
      };
    }

    // 🎙️ 2. Real-Time Scan (New /scanner route)
    if (_matches(text, [
      "scan",
      "scanner",
      "camera",
      "capture",
      "bimari",
      "pest",
      "detect",
      "identify"
    ])) {
      return {
        "route": "/scanner",
        "response": "Opening real-time crop scanner.",
        "flow": "cropScan",
      };
    }

    // 🎙️ 3. Static Upload / Gallery
    if (_matches(text, ["upload", "gallery", "photo", "choose"])) {
      return {
        "route": "/upload",
        "response": "Opening image upload.",
        "flow": "cropScan", // Reuses same guided instructions
      };
    }

    // 🎙️ 4. Mandi Prices
    if (_matches(
        text, ["mandi", "price", "market", "daam", "bhav", "rates"])) {
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
      "dap"
    ])) {
      return {
        "route": "/fertilizer",
        "response": "Opening fertilizer calculator.",
        "flow": "fertilizer",
      };
    }

    // 🎙️ 6. Crop Suggestion / Recommendation
    if (_matches(
        text, ["crop", "recommend", "suggest", "advice", "fasal"])) {
      // Note: "scan crop" is handled by higher priority rule #2
      return {
        "route": "/crop_recommend",
        "response": "Opening crop recommendations.",
        "flow": "cropRecommend",
      };
    }

    // 🎙️ 7. Government Schemes
    if (_matches(text, ["scheme", "yojana", "government", "sarkar"])) {
      return {
        "route": "/schemes",
        "response": "Opening government schemes.",
      };
    }

    // 🎙️ 8. Wake Word Fallback: "Hey Kisan" (for general AI conversation)
    final wakeWords = [
      "hey kisan",
      "hey kishan",
      "hey kissan",
      "hi kisan",
      "hey kisan ji",
      "hey kisaan",
      "kisan kisan",
      "kissan kissan",
      "digital agronomist"
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
      "response":
          "Sorry, I did not understand. Try saying 'Mandi price' or 'Scan crop'.",
    };
  }
}
