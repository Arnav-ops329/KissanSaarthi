import 'package:flutter/material.dart';
import '../models/crop_price.dart';
import '../services/market_price_service.dart';

class AppProvider extends ChangeNotifier {
  // 🔹 Disease Result (existing)
  String diseaseResult = "";

  void setResult(String result) {
    diseaseResult = result;
    notifyListeners();
  }

  // 🔹 Mandi Prices (NEW FEATURE)
  List<CropPrice> cropPrices = [];
  bool isLoadingPrices = false;
  String selectedCrop = "Wheat";

  Future<void> loadCropPrices(String crop) async {
    selectedCrop = crop;
    isLoadingPrices = true;
    notifyListeners();

    try {
      cropPrices = await MarketPriceService.fetchPrices(crop);
    } catch (e) {
      debugPrint("Error fetching prices: $e");
    }

    isLoadingPrices = false;
    notifyListeners();
  }

  CropPrice? get bestMarket {
    if (cropPrices.isEmpty) return null;

    return cropPrices.reduce(
      (a, b) => a.modalPrice > b.modalPrice ? a : b,
    );
  }
}
