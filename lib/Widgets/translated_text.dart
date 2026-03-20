import 'package:flutter/material.dart';
import 'package:kissansaarthi/services/translation_service.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final String langCode;
  final TextStyle? style;

  const TranslatedText({
    super.key,
    required this.text,
    required this.langCode,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: TranslationService.translate(text, langCode),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(text, style: style);
        }

        return Text(
          snapshot.data ?? text,
          style: style,
        );
      },
    );
  }
}
