import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class DiseaseApiService {
  static const String apiUrl =
      "https://kissan-saarthi-api.onrender.com/predict";

  static const String apiKey = "LsCqEFjF1QHgvC3mSeyg4BG2Z_ZcSi3UDWlk8sEnSBo";

  static Future<Map<String, dynamic>> detectDisease(String imagePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(apiUrl),
      );

      /// API KEY HEADER REQUIRED BY SERVER
      request.headers['X-API-Key'] = apiKey;

      /// IMAGE FILE
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imagePath,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      print("Sending request to API...");

      var response = await request.send();

      print("STATUS CODE: ${response.statusCode}");

      var responseBody = await response.stream.bytesToString();

      print("SERVER RESPONSE: $responseBody");

      if (response.statusCode == 200) {
        return json.decode(responseBody);
      } else {
        return {
          "disease": "API Error",
          "confidence": "0",
          "solution": "Server returned error ${response.statusCode}"
        };
      }
    } catch (e) {
      print("ERROR: $e");

      return {
        "disease": "Connection Error",
        "confidence": "0",
        "solution": "Failed to connect to server"
      };
    }
  }
}
