class VoiceCommandService {
  static Map<String, String> processCommand(String text) {
    text = text.toLowerCase();

    /// 🎯 DEFAULT RESPONSE
    String route = "";
    String response = "Samajh nahi aaya, dobara boliye";

    /// 📸 SCAN
    if (text.contains("scan") ||
        text.contains("camera") ||
        text.contains("स्कैन")) {
      route = "/scanner";
      response = "Opening scanner";
    }

    /// 💰 MANDI
    else if (text.contains("mandi") ||
        text.contains("price") ||
        text.contains("दाम")) {
      route = "/market";
      response = "Opening mandi prices";
    }

    /// 🌱 FERTILIZER
    else if (text.contains("fertilizer") || text.contains("खाद")) {
      route = "/fertilizer";
      response = "Opening fertilizer calculator";
    }

    /// 🌾 CROP
    else if (text.contains("crop") || text.contains("फसल")) {
      route = "/crop_recommend";
      response = "Suggesting crops";
    }

    /// 📜 SCHEMES
    else if (text.contains("scheme") ||
        text.contains("yojana") ||
        text.contains("योजना")) {
      route = "/schemes";
      response = "Opening government schemes";
    }

    /// 🌦 WEATHER
    else if (text.contains("weather") || text.contains("मौसम")) {
      route = "/weather";
      response = "Showing weather";
    }

    return {
      "route": route,
      "response": response,
    };
  }
}
