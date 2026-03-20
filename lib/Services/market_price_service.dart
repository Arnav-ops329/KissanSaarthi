import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/crop_price.dart';

class MarketPriceService {
  static Future<List<CropPrice>> fetchPrices(String crop) async {
    final url = Uri.parse(
      "http://10.0.2.2:5000/api/prices?crop=$crop",
    );

    debugPrint("Calling API: $url");

    final response = await http.get(url);

    debugPrint("Response: ${response.body}");

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => CropPrice.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load prices");
    }
  }
}
