import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../providers/voice_flow_provider.dart';
import '../Widgets/global_voice_button.dart';

class CropRecommendationScreen extends StatefulWidget {
  const CropRecommendationScreen({super.key});

  @override
  State<CropRecommendationScreen> createState() => _CropRecommendationScreenState();
}

class _CropRecommendationScreenState extends State<CropRecommendationScreen> {
  String location = "Detecting...";
  String weather = "Loading...";
  double? temp;
  String result = "";

  String selectedSoil = "Alluvial";
  String selectedSeason = "Kharif";

  @override
  void initState() {
    super.initState();
    loadLocationAndWeather();
  }

  Future loadLocationAndWeather() async {
    try {
      await Geolocator.requestPermission();
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final data = await WeatherService.getWeatherByLocation(position.latitude, position.longitude);

      setState(() {
        location = "Lat: ${position.latitude.toStringAsFixed(2)}, Lon: ${position.longitude.toStringAsFixed(2)}";
        weather = data["weather"];
        temp = (data["temp"] as num).toDouble();
      });
    } catch (e) {
      setState(() {
        location = "Location (Default)";
        weather = "Clear";
        temp = 28;
      });
    }
  }

  void recommendCrop() {
    Map<String, int> cropPrices = {"Wheat": 2300, "Rice": 2100, "Maize": 1800, "Mustard": 2500, "Sugarcane": 3000};
    List<String> suitableCrops = [];

    if (selectedSoil == "Black") {
      suitableCrops = ["Cotton", "Soybean"];
    } else if (selectedSeason == "Rabi") {
      suitableCrops = ["Wheat", "Mustard"];
    } else if (selectedSeason == "Kharif") {
      suitableCrops = ["Rice", "Maize"];
    } else {
      suitableCrops = ["Sugarcane", "Potato"];
    }

    String bestCrop = suitableCrops[0];
    int maxPrice = cropPrices[bestCrop] ?? 2000;

    setState(() {
      result = """
🌾 Recommended: $bestCrop
💰 Market Rate: ₹$maxPrice/quintal
🌱 Soil Type: $selectedSoil
📅 Season: $selectedSeason

📍 Based on your $weather climate conditions.
""";
    });
  }

  @override
  Widget build(BuildContext context) {
    final voiceFlow = Provider.of<VoiceFlowProvider>(context);

    // Automation: Sync with Voice Assistant
    if (voiceFlow.activeFlow == VoiceFlow.cropRecommend) {
      if (voiceFlow.data.containsKey('soil')) {
        selectedSoil = voiceFlow.data['soil']!;
      }
      if (voiceFlow.data.containsKey('season')) {
        selectedSeason = voiceFlow.data['season']!;
        // Auto-run recommendation when both are present
        Future.microtask(() => recommendCrop());
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F5),
      appBar: AppBar(
        title: const Text("Crop Advisor AI"),
        backgroundColor: Colors.green,
        actions: [
          if (voiceFlow.activeFlow == VoiceFlow.cropRecommend)
            IconButton(onPressed: () => voiceFlow.stopFlow(), icon: const Icon(Icons.stop_circle, color: Colors.orange))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            if (voiceFlow.activeFlow == VoiceFlow.cropRecommend)
              _buildVoiceGuidance(voiceFlow.lastGuidance),
            
            _buildInfoRow(Icons.location_on, "Your Location", location),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.wb_sunny, "Climate", "$weather | ${temp?.toStringAsFixed(0) ?? '--'}°C"),
            const SizedBox(height: 24),

            const Text("Personalize Advice", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildDropdown("Soil Type", selectedSoil, ["Alluvial", "Black", "Sandy"], (val) => setState(() => selectedSoil = val!)),
            const SizedBox(height: 16),
            _buildDropdown("Season", selectedSeason, ["Kharif", "Rabi", "Zaid"], (val) => setState(() => selectedSeason = val!)),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: recommendCrop,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text("Get Smart Recommendation", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),

            if (result.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.green.shade200), boxShadow: [BoxShadow(color: Colors.green.withAlpha(13), blurRadius: 10)]),
                child: Text(result, style: const TextStyle(fontSize: 16, height: 1.6)),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: const GlobalVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildVoiceGuidance(String guidance) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.green.shade200)),
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.green, size: 28),
          const SizedBox(width: 12),
          Expanded(child: Text(guidance, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey, size: 20),
        const SizedBox(width: 8),
        Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.black87), overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
