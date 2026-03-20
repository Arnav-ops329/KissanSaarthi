import 'package:flutter/material.dart';
import '../Services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double? temperature;
  String weather = "";

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future loadWeather() async {
    var data = await WeatherService.getWeather();

    setState(() {
      temperature = data["temp"];
      weather = data["weather"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather & Monsoon"),
      ),
      body: Center(
        child: temperature == null
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${temperature!.toStringAsFixed(0)}°C",
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    weather,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
