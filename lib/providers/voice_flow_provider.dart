import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum VoiceFlow { none, fertilizer, mandiPrice, weatherQuery, cropScan, cropRecommend }

class VoiceFlowProvider extends ChangeNotifier {
  VoiceFlow activeFlow = VoiceFlow.none;
  int stepIndex = 0;
  Map<String, String> data = {};
  
  final FlutterTts _tts = FlutterTts();
  String lastGuidance = "";

  VoiceFlowProvider() {
    _tts.setLanguage("en-IN"); // Standard Indian English
  }

  Future<void> speak(String text) async {
    lastGuidance = text;
    notifyListeners();
    await _tts.speak(text);
  }

  void startFertilizerFlow() {
    activeFlow = VoiceFlow.fertilizer;
    stepIndex = 0;
    data = {};
    speak("Sure! Let's calculate your fertilizer. First, what crop are you growing? Wheat, Rice, Potato, or Tomato?");
    notifyListeners();
  }

  void startMandiFlow({String? initialCrop}) {
    activeFlow = VoiceFlow.mandiPrice;
    data = {};
    if (initialCrop != null) {
      data['crop'] = initialCrop[0].toUpperCase() + initialCrop.substring(1);
      speak("Checking ${data['crop']} prices for you. Navigating to the market screen.");
      stepIndex = 1; // Completed
    } else {
      stepIndex = 0;
      speak("Which crop's price would you like to know? Wheat, Rice, Potato, Tomato, or Cotton?");
    }
    notifyListeners();
  }

  void startWeatherFlow(Map<String, dynamic>? weather, String city) {
    activeFlow = VoiceFlow.weatherQuery;
    stepIndex = 0;
    data = {};
    if (weather != null) {
      String report = "In $city, the weather is ${weather['weather']}. The temperature is ${weather['temp'].toStringAsFixed(0)} degrees with ${weather['humidity']}% humidity.";
      speak(report);
    } else {
      speak("I'm sorry, I couldn't fetch the weather data right now.");
    }
    notifyListeners();
  }

  void startCropScanFlow() {
    activeFlow = VoiceFlow.cropScan;
    stepIndex = 0;
    data = {};
    speak("Opening the crop scanner. Please take a clear photo of the infected part of the plant or upload one from your gallery for diagnosis.");
    notifyListeners();
  }

  void startCropRecommendFlow() {
    activeFlow = VoiceFlow.cropRecommend;
    stepIndex = 0;
    data = {};
    speak("I can help you choose the best crop. What is your soil type? Alluvial, Black, or Sandy?");
    notifyListeners();
  }

  void stopFlow() {
    activeFlow = VoiceFlow.none;
    stepIndex = 0;
    data = {};
    lastGuidance = "";
    notifyListeners();
  }

  /// Returns true if the input was handled by an active flow
  bool handleInput(String text, BuildContext context) {
    if (activeFlow == VoiceFlow.none) {
      return false;
    }

    text = text.toLowerCase().trim();

    if (activeFlow == VoiceFlow.fertilizer) {
      return _processFertilizerStep(text, context);
    }

    if (activeFlow == VoiceFlow.mandiPrice) {
      return _processMandiPriceStep(text, context);
    }

    if (activeFlow == VoiceFlow.cropRecommend) {
      return _processCropRecommendStep(text, context);
    }

    return false;
  }

  bool _processFertilizerStep(String text, BuildContext context) {
    if (stepIndex == 0) {
      // Expecting Crop
      final crops = ["wheat", "rice", "potato", "tomato"];
      String? identifiedCrop;
      for (var c in crops) {
        if (text.contains(c)) {
          identifiedCrop = c[0].toUpperCase() + c.substring(1);
          break;
        }
      }

      if (identifiedCrop != null) {
        data['crop'] = identifiedCrop;
        stepIndex++;
        speak(
            "Got it, $identifiedCrop. Now, what is your land area in acres?");
        notifyListeners();
        return true;
      } else {
        speak(
            "I didn't catch the crop. Please say Wheat, Rice, Potato, or Tomato.");
        return true;
      }
    } else if (stepIndex == 1) {
      // Expecting Area
      RegExp regExp = RegExp(r"(\d+(\.\d+)?)");
      var match = regExp.firstMatch(text);
      if (match != null) {
        String areaStr = match.group(0)!;
        data['area'] = areaStr;
        stepIndex++;

        speak(
            "Thank you. Calculating $foundCrop fertilizer for $areaStr acres. Check your screen for the results.");

        notifyListeners();
        return true;
      } else {
        speak("Please tell me the area in numbers, for example, 5 acres.");
        return true;
      }
    }

    return false;
  }

  bool _processMandiPriceStep(String text, BuildContext context) {
    if (stepIndex == 0) {
      final crops = ["wheat", "rice", "potato", "tomato", "cotton"];
      String? identifiedCrop;
      for (var c in crops) {
        if (text.contains(c)) {
          identifiedCrop = c[0].toUpperCase() + c.substring(1);
          break;
        }
      }

      if (identifiedCrop != null) {
        data['crop'] = identifiedCrop;
        stepIndex++;
        speak("Searching for $identifiedCrop prices. Just a moment.");
        notifyListeners();
        return true;
      } else {
        speak("Please say a crop name like Wheat or Rice.");
        return true;
      }
    }
    return false;
  }

  bool _processCropRecommendStep(String text, BuildContext context) {
    if (stepIndex == 0) {
      final soils = ["alluvial", "black", "sandy"];
      for (var s in soils) {
        if (text.contains(s)) {
          data['soil'] = s[0].toUpperCase() + s.substring(1);
          stepIndex++;
          speak("Got it, ${data['soil']} soil. Now, which season is it? Kharif, Rabi, or Zaid?");
          notifyListeners();
          return true;
        }
      }
      speak("Please say your soil type: Alluvial, Black, or Sandy.");
      return true;
    } else if (stepIndex == 1) {
      final seasons = ["kharif", "rabi", "zaid"];
      for (var s in seasons) {
        if (text.contains(s)) {
          data['season'] = s[0].toUpperCase() + s.substring(1);
          stepIndex++;
          speak("Thank you. I am calculating the best crop for ${data['soil']} soil in ${data['season']} season. Check your screen for recommendations.");
          notifyListeners();
          return true;
        }
      }
      speak("Please say the season: Kharif, Rabi, or Zaid.");
      return true;
    }
    return false;
  }

  String get foundCrop => data['crop'] ?? "Wheat";
  String get foundArea => data['area'] ?? "1";
}
