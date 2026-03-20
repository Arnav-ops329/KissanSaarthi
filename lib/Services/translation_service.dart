import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static Future<String> translate(String text, String targetLang) async {
    try {
      final url =
          "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$targetLang&dt=t&q=$text";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data[0][0][0];
      } else {
        return text;
      }
    } catch (e) {
      return text; // fallback
    }
  }
}
