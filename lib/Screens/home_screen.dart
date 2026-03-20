import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../Widgets/global_voice_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();

  Future<void> _handleScanAction(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null && mounted) {
      Navigator.pushNamed(context, "/upload", arguments: pickedFile.path);
    }
  }
  @override
  Widget build(BuildContext context) {
    final appProv = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(),
              const SizedBox(height: 20),
              _buildPrecisionBanner(),
              const SizedBox(height: 20),
              _buildWeatherCard(appProv),
              const SizedBox(height: 20),
              _buildMainFeatureCards(),
              const SizedBox(height: 20),
              _buildSmallFeatureList(),
              const SizedBox(height: 100), // Space for voice button
            ],
          ),
        ),
      ),
      floatingActionButton: const GlobalVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        const Icon(Icons.eco, color: Color(0xFF2E7D32), size: 30),
        const SizedBox(width: 8),
        const Text(
          "KisaanSaarthi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2E7D32),
          ),
        ),
        const Spacer(),
        const SizedBox(width: 15),
        const CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/1118/1118931.png'),
        ),
      ],
    );
  }

  Widget _buildPrecisionBanner() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: FileImage(File(
              'C:/Users/User/.gemini/antigravity/brain/127276db-1cd1-4900-980f-e689f4ccf547/precision_farming_banner_1774043652550.png')),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [Colors.black.withAlpha(150), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.agriculture,
                      color: Color(0xFF2E7D32), size: 30),
                ),
                const SizedBox(width: 15),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("AI-powered",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    Text("SMART FARMER AI",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900)),
                    Text("Monitoring your field's health",
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(AppProvider provider) {
    final weather = provider.weatherData;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.wb_sunny, color: Colors.orange, size: 40),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        weather?['weather'] ?? "Partly Cloudy",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "Humidity ${weather?['humidity'] ?? 64}%",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "${(weather?['temp'] ?? 28).toStringAsFixed(0)}°C",
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2E7D32)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lightbulb, color: Colors.brown, size: 16),
              const SizedBox(width: 8),
              const Text("SMART TIP",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.brown)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            "Perfect weather for nitrogen application today.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF2E7D32)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeatureCards() {
    return Column(
      children: [
        _largeFeatureCard(
          title: "Scan Crop",
          subtitle: "Identify pests and diseases instantly using AI.",
          icon: Icons.filter_center_focus,
          baseColor: const Color(0xFF2E7D32),
          textColor: Colors.white,
          onTap: () => _handleScanAction(ImageSource.camera),
        ),
        const SizedBox(height: 16),
        _largeFeatureCard(
          title: "Upload Image",
          subtitle: "Analyze previously taken photos from your gallery.",
          icon: Icons.add_to_photos,
          baseColor: Colors.white,
          textColor: const Color(0xFF2E7D32),
          hasPlus: true,
          onTap: () => _handleScanAction(ImageSource.gallery),
        ),
      ],
    );
  }

  Widget _largeFeatureCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color baseColor,
    required Color textColor,
    bool hasPlus = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            if (baseColor == Colors.white)
              BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 10,
                  offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: textColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: textColor, size: 30),
                ),
                if (!hasPlus) Icon(Icons.arrow_forward, color: textColor),
              ],
            ),
            const SizedBox(height: 20),
            Text(title,
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: textColor)),
            const SizedBox(height: 4),
            Text(subtitle,
                style:
                    TextStyle(fontSize: 14, color: textColor.withAlpha(180))),
            if (hasPlus) ...[
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                      radius: 12,
                      backgroundColor: textColor.withAlpha(40),
                      child: Icon(Icons.add, color: textColor, size: 16))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSmallFeatureList() {
    return Column(
      children: [
        _smallFeatureRow(
            "Mandi Prices",
            "Real-time market rates and trend analysis.",
            Icons.attach_money,
            Colors.orange.shade800,
            "/market"),
        const SizedBox(height: 12),
        _smallFeatureRow(
            "Fertilizer",
            "Nutrition plans and fertilizer calculators.",
            Icons.science,
            Colors.teal,
            "/fertilizer"),
        const SizedBox(height: 12),
        _smallFeatureRow(
            "Crop Suggest",
            "Smart recommendations based on your soil.",
            Icons.psychology,
            Colors.blueGrey,
            "/crop_recommend"),
      ],
    );
  }

  Widget _smallFeatureRow(
      String title, String subtitle, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: color.withAlpha(30), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 16)),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
