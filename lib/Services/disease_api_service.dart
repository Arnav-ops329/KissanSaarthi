import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// NOTE: This service is dedicated to ONLINE disease detection via a remote API.
/// For OFFLINE detection using the built-in YOLO model, see [YoloOfflineService].
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

      debugPrint("Sending request to: ${Uri.parse(apiUrl)}");
      debugPrint("Headers: ${request.headers}");

      var response = await request.send();

      debugPrint("STATUS CODE: ${response.statusCode} for ${response.request?.url}");

      var responseBody = await response.stream.bytesToString();

      debugPrint("SERVER RESPONSE: $responseBody");

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
      debugPrint("ERROR: $e");

      return {
        "disease": "Connection Error",
        "confidence": "0",
        "solution": "Failed to connect to server"
      };
    }
  }
}
