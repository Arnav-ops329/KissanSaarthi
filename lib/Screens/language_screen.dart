import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../localization/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.loc('select_language'))),
      body: Column(
        children: [
          /// 🇬🇧 ENGLISH
          ListTile(
            title: const Text("English"),
            onTap: () {
              localeProvider.setLocale('en');
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          /// 🇮🇳 HINDI
          ListTile(
            title: const Text("हिंदी"),
            onTap: () {
              localeProvider.setLocale('hi');
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            title: Text("বাংলা"),
            onTap: () {
              localeProvider.setLocale('bn');
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          ListTile(
            title: Text("मराठी"),
            onTap: () {
              localeProvider.setLocale('mr');
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),

          ListTile(
            title: Text("தமிழ்"),
            onTap: () {
              localeProvider.setLocale('ta');
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
    );
  }
}
