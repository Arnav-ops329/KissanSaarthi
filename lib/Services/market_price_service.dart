import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/crop_price.dart';

class MarketPriceService {
  static Future<List<CropPrice>> fetchPrices(String crop,
      {String? location}) async {
    final List<String> paths = [
      "https://kissan-saarthi-api.onrender.com/prices?crop=$crop&location=${location ?? ''}",
      "https://kissan-saarthi-api.onrender.com/api/prices?crop=$crop&location=${location ?? ''}",
    ];

    for (String urlStr in paths) {
      final url = Uri.parse(urlStr);
      debugPrint("Attempting Mandi API: $url");

      try {
        final response =
            await http.get(url).timeout(const Duration(seconds: 10));

        debugPrint("Mandi Response (${response.statusCode}) from $urlStr");

        if (response.statusCode == 200) {
          List data = jsonDecode(response.body);
          if (data.isNotEmpty) {
            return data.map((e) => CropPrice.fromJson(e)).toList();
          }
        }
      } catch (e) {
        debugPrint("Mandi API Attempt failed ($urlStr): $e");
      }
    }

    // 🛡️ FALLBACK: Return Mock Data with nearby mandi logic
    debugPrint("Returning Localized Mock Data for: $crop in $location");
    return _getMockPrices(crop, location: location);
  }

  static List<CropPrice> _getMockPrices(String crop, {String? location}) {
    final List<CropPrice> prices = [];

    // 📍 Add Nearby Mandi if location is available
    if (location != null &&
        location.isNotEmpty &&
        location != "Unknown Location" &&
        location != "Detecting...") {
      prices.add(
        CropPrice(
          market: "$location Mandi (Nearby)",
          crop: crop,
          minPrice: 2200,
          maxPrice: 2600,
          modalPrice: 2400,
          // Use a dummy "local" coord (e.g., Delhi if unknown, but better if we just flag it as 1.5km)
          latitude: 28.6139, 
          longitude: 77.2090,
        ),
      );
    }

    prices.addAll([
      CropPrice(
        market: "Azadpur Mandi, Delhi",
        crop: crop,
        minPrice: 2100,
        maxPrice: 2450,
        modalPrice: 2300,
        latitude: 28.7180,
        longitude: 77.1684,
      ),
      CropPrice(
        market: "Vashi Mandi, Mumbai",
        crop: crop,
        minPrice: 2150,
        maxPrice: 2500,
        modalPrice: 2350,
        latitude: 19.0760,
        longitude: 72.9992,
      ),
      CropPrice(
        market: "Jaipur Mandi, Rajasthan",
        crop: crop,
        minPrice: 2050,
        maxPrice: 2350,
        modalPrice: 2200,
        latitude: 26.9124,
        longitude: 75.7873,
      ),
      CropPrice(
        market: "Lucknow Mandi, UP",
        crop: crop,
        minPrice: 2000,
        maxPrice: 2300,
        modalPrice: 2150,
        latitude: 26.8467,
        longitude: 80.9462,
      ),
    ]);

    return prices;
  }
}
