import 'dart:math';

class AIService {
  static const List<String> _responses = [
    "I recommend monitoring soil moisture levels daily during the summer.",
    "Using organic compost can significantly improve your crop yield over time.",
    "Make sure to rotate your crops every season to prevent soil depletion.",
    "For the best results, apply fertilizer early in the morning or late in the evening.",
    "Keep an eye out for any unusual spots on leaves; they could indicate early-stage disease.",
    "Drip irrigation is the most water-efficient way to hydrate your plants.",
    "Namaste! How can I help you with your farming tasks today?",
  ];

  static Future<String> getAIResponse(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // Simple mock logic for specific keywords
    final lowerQuery = query.toLowerCase();
    if (lowerQuery.contains("price") || lowerQuery.contains("mandi")) {
      return "You can check the latest Mandi prices in the Mandi section of the app.";
    } else if (lowerQuery.contains("weather") || lowerQuery.contains("rain")) {
      return "Current weather reports are available on your home dashboard.";
    } else if (lowerQuery.contains("disease") || lowerQuery.contains("plant")) {
      return "You can scan your plant using the 'Crop Scan' feature for a detailed diagnosis.";
    }

    // Default random helpful tip
    return _responses[Random().nextInt(_responses.length)];
  }
}
