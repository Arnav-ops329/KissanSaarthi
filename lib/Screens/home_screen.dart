import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../services/weather_service.dart';
import '../services/voice_command_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double temp = 28;
  int humidity = 60;
  String weather = "Partly Cloudy";

  late stt.SpeechToText _speech;
  late FlutterTts tts;

  bool isListening = false;

  late AnimationController _controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();

    loadWeather();

    _speech = stt.SpeechToText();
    tts = FlutterTts();

    tts.setLanguage("hi-IN");

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    /// 🔥 AUTO START VOICE
    Future.delayed(const Duration(seconds: 2), () {
      startListening();
    });
  }

  Future<void> loadWeather() async {
    var data = await WeatherService.getWeather();

    setState(() {
      temp = (data["temp"] as num).toDouble();
      humidity = data["humidity"];
      weather = data["weather"];
    });
  }

  Future<void> speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }

  void startListening() async {
    bool available = await _speech.initialize();

    if (available) {
      setState(() => isListening = true);

      _speech.listen(
        listenOptions: stt.SpeechListenOptions(
          listenMode: stt.ListenMode.confirmation,
          partialResults: true,
        ),
        onResult: (result) async {
          String text = result.recognizedWords.toLowerCase();

          if (text.isNotEmpty) {
            final action = VoiceCommandService.processCommand(text);

            final safe = Map<String, String>.from(action);

            String route = safe["route"] ?? "";
            String response = safe["response"] ?? "";

            await speak(response);

            if (route.isNotEmpty && mounted) {
              Navigator.pushNamed(context, route);
            }
          }

          /// 🔁 RESTART LISTENING (IMPORTANT)
          if (result.finalResult) {
            _speech.stop();

            Future.delayed(const Duration(milliseconds: 500), () {
              startListening();
            });
          }
        },
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),

      /// 🎤 VOICE BUTTON WITH PULSE
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: isListening
              ? [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.6),
                    blurRadius: 20,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: FloatingActionButton(
          onPressed: startListening,
          backgroundColor: Colors.green,
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),

      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// 🔝 HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.eco, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            "KissanSaarthi",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/tractor.png"),
                      )
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// 🌾 HERO CARD
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      image: const DecorationImage(
                        image: AssetImage("assets/Tractor2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: Colors.black.withValues(alpha: 0.3),
                      ),
                      child: const Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "AI-based farmer assistant",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🌦 WEATHER CARD
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny, size: 40),
                            const SizedBox(width: 10),
                            Text(
                              "${temp.toStringAsFixed(0)}°C",
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(weather),
                        Text("Humidity: $humidity%"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📸 SCAN
                  featureCard(
                    "Scan Crop",
                    "Identify pests and diseases instantly using AI.",
                    Colors.green,
                    "/scanner",
                  ),

                  const SizedBox(height: 16),

                  /// 📤 UPLOAD
                  featureCard(
                    "Upload Image",
                    "Analyze previously taken photos.",
                    Colors.grey.shade300,
                    "/upload",
                    textColor: Colors.black,
                  ),

                  const SizedBox(height: 16),

                  simpleCard("Mandi Prices", "/market"),
                  const SizedBox(height: 12),
                  simpleCard("Fertilizer", "/fertilizer"),
                  const SizedBox(height: 12),
                  simpleCard("Crop Suggest", "/crop_recommend"),
                  simpleCard("Government Schemes", "/schemes"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 BIG CARD
  Widget featureCard(String title, String subtitle, Color color, String route,
      {Color textColor = Colors.white}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.qr_code_scanner, color: textColor),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(subtitle,
                style: TextStyle(color: textColor.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }

  /// 🔹 SMALL CARD
  Widget simpleCard(String title, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            const Icon(Icons.circle, size: 12),
            const SizedBox(width: 10),
            Text(title),
          ],
        ),
      ),
    );
  }
}
