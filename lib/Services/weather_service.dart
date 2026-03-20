import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = "b868e07650a9c34fc79a646338786cfe";

  /// 🌆 CITY WEATHER (OLD - KEEP)
  static Future<Map<String, dynamic>> getWeather() async {
    try {
      const city = "Delhi";

      final url =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          "temp": data["main"]["temp"],
          "weather": data["weather"][0]["main"],
          "humidity": data["main"]["humidity"],
          "wind": data["wind"]["speed"]
        };
      } else {
        throw Exception("City API Failed");
      }
    } catch (e) {
      print("CITY WEATHER ERROR: $e");

      return {"temp": 28, "weather": "Clear", "humidity": 60, "wind": 2};
    }
  }

  /// 📍 NEW: LOCATION WEATHER (THIS FIXES YOUR ERROR)
  static Future<Map<String, dynamic>> getWeatherByLocation(
      double lat, double lon) async {
    try {
      final url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=$apiKey";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          "temp": data["main"]["temp"],
          "weather": data["weather"][0]["main"],
          "humidity": data["main"]["humidity"],
          "wind": data["wind"]["speed"],
          "city": data["name"],
        };
      } else {
        throw Exception("Location API Failed");
      }
    } catch (e) {
      print("LOCATION WEATHER ERROR: $e");

      /// fallback
      return await getWeather();
    }
  }
}
