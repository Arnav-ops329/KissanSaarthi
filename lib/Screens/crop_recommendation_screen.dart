import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() =>
      _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  String location = "Detecting...";
  String weather = "Loading...";
  double? temp;

  String result = "";

  @override
  void initState() {
    super.initState();
    loadLocationAndWeather();
  }

  /// 📍 GET LOCATION + WEATHER
  Future loadLocationAndWeather() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      final data = await WeatherService.getWeatherByLocation(
          position.latitude, position.longitude);

      setState(() {
        location =
            "Lat: ${position.latitude.toStringAsFixed(2)}, Lon: ${position.longitude.toStringAsFixed(2)}";
        weather = data["weather"];
        temp = (data["temp"] as num).toDouble();
      });
    } catch (e) {
      setState(() {
        location = "Location unavailable";
        weather = "Clear";
        temp = 28;
      });
    }
  }

  /// 🌾 SMART AI LOGIC
  void recommendCrop() {
    Map<String, int> cropPrices = {
      "Wheat": 2300,
      "Rice": 2100,
      "Maize": 1800,
      "Mustard": 2500,
      "Sugarcane": 3000,
    };

    List<String> suitableCrops = [];

    /// 🌦 Weather logic
    if (weather.contains("Rain")) {
      suitableCrops = ["Rice", "Sugarcane"];
    } else if (temp != null && temp! > 30) {
      suitableCrops = ["Maize", "Millets"];
    } else {
      suitableCrops = ["Wheat", "Mustard"];
    }

    /// 💰 Find most profitable crop
    String bestCrop = suitableCrops[0];
    int maxPrice = cropPrices[bestCrop] ?? 0;

    for (var crop in suitableCrops) {
      if ((cropPrices[crop] ?? 0) > maxPrice) {
        bestCrop = crop;
        maxPrice = cropPrices[crop]!;
      }
    }

    result = """
🌾 Best Crop: $bestCrop

💰 Expected Price: ₹$maxPrice/quintal

📊 Other Options:
${suitableCrops.join(", ")}

📍 Based on your weather & location
""";

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Crop Recommendation"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// 📍 LOCATION CARD
            card("📍 Location", location),

            const SizedBox(height: 10),

            /// 🌦 WEATHER CARD
            card("🌦 Weather",
                "$weather | ${temp?.toStringAsFixed(0) ?? '--'}°C"),

            const SizedBox(height: 20),

            /// 🔘 BUTTON
            ElevatedButton(
              onPressed: recommendCrop,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              child: const Text("Get Smart Recommendation"),
            ),

            const SizedBox(height: 20),

            /// 📊 RESULT
            if (result.isNotEmpty) card("🌾 Recommended Crops", result),
          ],
        ),
      ),
    );
  }

  Widget card(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Text(value),
        ],
      ),
    );
  }
}
