import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kissansaarthi/Screens/crop_recommendation_screen.dart';
import 'package:kissansaarthi/Widgets/no_glow_scroll.dart';
import 'package:provider/provider.dart';

import 'providers/app_provider.dart';
import 'providers/locale_provider.dart';

import 'services/translation_service.dart';

// Screens
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/language_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/upload_screen.dart';
import 'screens/result_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/market_screen.dart';
import 'screens/ai_chat_screen.dart';
import 'screens/fertilizer_screen.dart'; // NEW

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: const KissanSaarthiApp(),
    ),
  );
}

class KissanSaarthiApp extends StatelessWidget {
  const KissanSaarthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Kissan Saarthi",

      scrollBehavior: NoGlowScroll(),

      // 🌍 Localization
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('bn'), // Bengali
        Locale('mr'), // Marathi
        Locale('ta'), // Tamil
        Locale('te'), // Telugu
        Locale('gu'), // Gujarati
        Locale('kn'), // Kannada
        Locale('ml'), // Malayalam
        Locale('pa'), // Punjabi
        Locale('or'), // Odia
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🎯 Initial Screen
      initialRoute: '/',

      // 🎨 Theme (optional but good)
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F7F8),
      ),

      // 📍 Routes
      routes: {
        '/': (context) => SplashScreen(),
        '/language': (context) => const LanguageScreen(),
        '/home': (context) => const HomeScreen(),

        // 📸 Features
        '/scanner': (context) => ScannerScreen(),
        '/camera': (context) => CameraScreen(),
        '/upload': (context) => UploadScreen(),
        '/result': (context) => ResultScreen(),

        // 🌦 Weather
        '/weather': (context) => WeatherScreen(),

        // 💰 Mandi Prices
        '/market': (context) => MarketScreen(),

        // 🤖 AI Chat
        '/chat': (context) => AIChatScreen(),

        '/fertilizer': (context) => FertilizerScreen(),

        // 🌱 🔥 NEW FEATURE: Crop recommendation
        '/crop_recommend': (context) => CropRecommendationScreen(),
      },
    );
  }
}
