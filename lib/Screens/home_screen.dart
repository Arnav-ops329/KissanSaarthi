import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../Widgets/global_voice_button.dart';
import '../localization/app_localizations.dart';

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
      backgroundColor: const Color(0xFFF4F8F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildAppBar(context),
              const SizedBox(height: 20),
              _buildPrecisionBanner(context),
              const SizedBox(height: 20),
              _buildWeatherCard(context, appProv),
              const SizedBox(height: 20),
              _buildMainFeatureCards(context),
              const SizedBox(height: 20),
              _buildSmallFeatureList(context),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: const GlobalVoiceButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.eco, color: Color(0xFF1E5624), size: 28),
        const SizedBox(width: 8),
        Text(
          context.loc('app_title'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E5624),
          ),
        ),
        const Spacer(),
        const Icon(Icons.notifications, color: Color(0xFF4A6849), size: 24),
        const SizedBox(width: 15),
        const CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(
              'https://cdn-icons-png.flaticon.com/512/1118/1118931.png'),
        ),
      ],
    );
  }

  Widget _buildPrecisionBanner(BuildContext context) {
    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: const DecorationImage(
          image: AssetImage('assets/tractor.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                colors: [Colors.black.withAlpha(200), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDE6DF).withAlpha(220),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.agriculture,
                      color: Color(0xFF1E5624), size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.loc('ai_powered'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              height: 1.1,
                              fontWeight: FontWeight.w900)),
                      Text(context.loc('smart_farmer_ai'),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              height: 1.1,
                              fontWeight: FontWeight.w900)),
                      const SizedBox(height: 6),
                      Text(context.loc('monitoring_health'),
                          style: const TextStyle(
                              color: Colors.white70, 
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, AppProvider provider) {
    final weather = provider.weatherData;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3EE),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.wb_sunny, color: Color(0xFF1E5624), size: 52),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${(weather?['temp'] ?? 28).toStringAsFixed(0)}°C",
                      style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E5624)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(weather?['weather']?.split(' ').first ?? context.loc('partly_cloudy').split(' ').first, style: const TextStyle(color: Color(0xFF4A6849), fontSize: 13, fontWeight: FontWeight.bold)),
                              Text(weather?['weather']?.split(' ').last ?? context.loc('partly_cloudy').split(' ').last, style: const TextStyle(color: Color(0xFF4A6849), fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(context.loc('humidity'), style: const TextStyle(color: Color(0xFF4A6849), fontSize: 13, fontWeight: FontWeight.w500)),
                              Text("${weather?['humidity'] ?? 64}%", style: const TextStyle(color: Color(0xFF4A6849), fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lightbulb, color: Color(0xFF8D5321), size: 16),
              const SizedBox(width: 8),
              Text(context.loc('smart_tip').toUpperCase(),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Color(0xFF8D5321))),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            context.loc('weather_note_home'),
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E5624)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainFeatureCards(BuildContext context) {
    return Column(
      children: [
        _largeFeatureCard(
          title: context.loc('scan_crop'),
          subtitle: context.loc('scan_crop_desc'),
          icon: Icons.crop_free,
          baseColor: const Color(0xFF277134),
          textColor: Colors.white,
          iconBgColor: const Color(0xFF42894D),
          onTap: () => _handleScanAction(ImageSource.camera),
        ),
        const SizedBox(height: 16),
        _largeFeatureCard(
          title: context.loc('upload_image'),
          subtitle: context.loc('upload_image_desc'),
          icon: Icons.upload_file,
          baseColor: const Color(0xFFEEF3EE),
          textColor: const Color(0xFF1E5624),
          iconBgColor: Colors.white,
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
    required Color iconBgColor,
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
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(icon, color: textColor, size: 30),
                ),
                const SizedBox(height: 24),
                Text(title,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: textColor)),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(subtitle,
                      style: TextStyle(
                          fontSize: 14,
                          color: textColor.withAlpha(200))),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: hasPlus
                  ? CircleAvatar(
                      radius: 14,
                      backgroundColor: textColor.withAlpha(40),
                      child: Icon(Icons.add, color: textColor, size: 18))
                  : Icon(Icons.arrow_forward, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallFeatureList(BuildContext context) {
    return Column(
      children: [
        _smallFeatureRow(
            context.loc('mandi_prices'),
            context.loc('mandi_prices_desc'),
            Icons.attach_money,
            const Color(0xFF734B19),
            const Color(0xFFEADCC6),
            "/market"),
        const SizedBox(height: 12),
        _smallFeatureRow(
            context.loc('fertilizer'),
            context.loc('fertilizer_desc'),
            Icons.science,
            const Color(0xFF1E5624),
            const Color(0xFFDDE6DF),
            "/fertilizer"),
        const SizedBox(height: 12),
        _smallFeatureRow(
            context.loc('crop_suggest'),
            context.loc('crop_suggest_desc'),
            Icons.psychology,
            const Color(0xFF1E5624),
            const Color(0xFFDBE8D8),
            "/crop_recommend"),
      ],
    );
  }

  Widget _smallFeatureRow(
      String title, String subtitle, IconData icon, Color iconColor, Color iconBgColor, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF3EE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: iconBgColor, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Color(0xFF1E5624),
                          fontWeight: FontWeight.w900, 
                          fontSize: 16)),
                  const SizedBox(height: 4),    
                  Text(subtitle,
                      style: const TextStyle(color: Color(0xFF4A6849), fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
