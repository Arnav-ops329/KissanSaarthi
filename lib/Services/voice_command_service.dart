class VoiceCommandService {
  static Map<String, String> processCommand(String command) {
    command = command.toLowerCase();

    if (_contains(command, ["scan", "camera"])) {
      return {"route": "/scanner", "response": "Opening scanner"};
    }

    if (_contains(command, ["price", "mandi"])) {
      return {"route": "/market", "response": "Opening mandi"};
    }

    if (_contains(command, ["fertilizer", "khad"])) {
      return {"route": "/fertilizer", "response": "Opening fertilizer"};
    }

    if (_contains(command, ["crop", "fasal"])) {
      return {
        "route": "/crop_recommend",
        "response": "Opening crop suggestion"
      };
    }

    if (_contains(command, ["weather", "mausam"])) {
      return {"route": "/weather", "response": "Opening weather"};
    }

    return {"route": "", "response": "Samajh nahi aaya, dobara boliye"};
  }

  static bool _contains(String text, List<String> words) {
    for (var word in words) {
      if (text.contains(word)) return true;
    }
    return false;
  }
}
