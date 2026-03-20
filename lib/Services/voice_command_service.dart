class VoiceCommandService {
  static Map<String, String> processCommand(String text) {
    text = text.toLowerCase();

    if (text.contains("weather") || text.contains("mausam")) {
      return {
        "route": "/weather",
        "response": "Opening weather screen",
      };
    } else if (text.contains("market") ||
        text.contains("mandi") ||
        text.contains("price")) {
      return {
        "route": "/market",
        "response": "Opening mandi prices",
      };
    } else if (text.contains("scan") || text.contains("scanning")) {
      return {
        "route": "/scanner",
        "response": "Opening crop scanner",
      };
    } else if (text.contains("upload") || text.contains("photo")) {
      return {
        "route": "/upload",
        "response": "Opening upload screen",
      };
    } else if (text.contains("fertilizer") || text.contains("khad")) {
      return {
        "route": "/fertilizer",
        "response": "Opening fertilizer calculator",
      };
    } else if (text.contains("crop") || text.contains("fasal")) {
      return {
        "route": "/crop_recommend",
        "response": "Opening crop recommendation",
      };
    } else if (text.contains("scheme") || text.contains("yojana")) {
      return {
        "route": "/schemes",
        "response": "Opening government schemes",
      };
    } else if (text.contains("chat") || text.contains("assistant")) {
      return {
        "route": "/chat",
        "response": "Opening AI assistant",
      };
    }

    return {
      "route": "",
      "response": "Sorry, I did not understand. Please try again.",
    };
  }
}
