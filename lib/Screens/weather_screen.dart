import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/voice_flow_provider.dart';
import '../providers/app_provider.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        Provider.of<AppProvider>(context, listen: false).initApp();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppProvider>(context);
    final voiceFlow = Provider.of<VoiceFlowProvider>(context);
    final weather = provider.weatherData;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F7),
      appBar: AppBar(
        title: const Text("Weather Forecast"),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        actions: [
          if (voiceFlow.activeFlow == VoiceFlow.weatherQuery)
            IconButton(
                onPressed: () => voiceFlow.stopFlow(),
                icon: const Icon(Icons.stop_circle, color: Colors.red))
        ],
      ),
      body: provider.isInitialLoad
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildMainWeatherCard(provider, weather),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (voiceFlow.activeFlow == VoiceFlow.weatherQuery)
                          _buildVoiceGuidance(voiceFlow.lastGuidance),
                        const Text("Details",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF263238))),
                        const SizedBox(height: 16),
                        _buildWeatherDetailsGrid(weather),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildVoiceGuidance(String guidance) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.blue.shade200)),
      child: Row(
        children: [
          const Icon(Icons.mic, color: Colors.blueAccent, size: 28),
          const SizedBox(width: 12),
          Expanded(
              child: Text(guidance,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                      fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildMainWeatherCard(
      AppProvider provider, Map<String, dynamic>? weather) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF448AFF), Color(0xFF2979FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40), bottomRight: Radius.circular(40)),
      ),
      child: Column(
        children: [
          Text(provider.userCity,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(DateTime.now().toString().split(' ')[0],
              style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 30),
          Icon(_getWeatherIcon(weather?['weather']),
              color: Colors.white, size: 80),
          const SizedBox(height: 20),
          Text("${(weather?['temp'] ?? 0).toStringAsFixed(0)}°",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w200)),
          Text(weather?['weather'] ?? "N/A",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildWeatherDetailsGrid(Map<String, dynamic>? weather) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _detailCard(
            "Humidity", "${weather?['humidity'] ?? 0}%", Icons.water_drop, Colors.blue),
        _detailCard("Wind Speed",
            "${(weather?['wind'] ?? 0).toStringAsFixed(1)} km/h", Icons.air, Colors.teal),
        _detailCard("Pressure", "${weather?['pressure'] ?? 1013} hPa",
            Icons.compress, Colors.orange),
        _detailCard(
            "Visibility",
            "${(weather?['visibility'] ?? 10000) / 1000} km",
            Icons.visibility,
            Colors.purple),
      ],
    );
  }

  Widget _detailCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          Text(value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String? condition) {
    condition = condition?.toLowerCase() ?? "";
    if (condition.contains("cloud")) return Icons.cloud;
    if (condition.contains("rain")) return Icons.umbrella;
    if (condition.contains("clear")) return Icons.wb_sunny;
    return Icons.wb_cloudy;
  }
}
