import 'package:flutter/material.dart';
import '../models/crop_price.dart';
import 'package:geolocator/geolocator.dart';
import '../services/weather_service.dart';
import '../services/market_price_service.dart';
import '../services/location_service.dart';

class AppProvider extends ChangeNotifier {
  // 🔹 Global State
  String userCity = "Detecting...";
  double? lat;
  double? lon;
  Map<String, dynamic>? weatherData;
  bool isInitialLoad = true;

  // 🔹 Disease Result
  String diseaseResult = "";

  void setResult(String result) {
    diseaseResult = result;
    notifyListeners();
  }

  // 🔹 Mandi Prices
  List<CropPrice> cropPrices = [];
  bool isLoadingPrices = false;
  String selectedCrop = "Wheat";
  void setSelectedCrop(String crop) {
    if (crop == "General" || crop.isEmpty || crop == "Unknown") return;
    selectedCrop = crop;
    loadCropPrices(crop);
    notifyListeners();
  }

  bool isDescendingOrder = true;

  /// 📍 INITIALIZE EVERYTHING
  Future<void> initApp() async {
    isInitialLoad = true;
    notifyListeners();

    try {
      // 1. Get exact coordinates
      Position position = await Geolocator.getCurrentPosition();
      lat = position.latitude;
      lon = position.longitude;

      // 2. Get City Name
      userCity = await LocationService.getCurrentCity();

      // 3. Get Weather
      weatherData = await WeatherService.getWeatherByLocation(lat!, lon!);
      
      // 4. Load initial Mandi prices
      await loadCropPrices(selectedCrop);
    } catch (e) {
      debugPrint("Init Error: $e");
      // Fallback to defaults
      userCity = "Delhi";
      weatherData = await WeatherService.getWeather();
    }

    isInitialLoad = false;
    notifyListeners();
  }

  Future<void> loadCropPrices(String crop) async {
    selectedCrop = crop;
    isLoadingPrices = true;
    notifyListeners();

    try {
      if (userCity == "Detecting...") {
        userCity = await LocationService.getCurrentCity();
      }
      final fetchedPrices = await MarketPriceService.fetchPrices(crop, location: userCity);
      cropPrices = fetchedPrices;
      _sortPrices();
    } catch (e) {
      debugPrint("Error fetching prices: $e");
    }

    isLoadingPrices = false;
    notifyListeners();
  }

  void toggleSortOrder() {
    isDescendingOrder = !isDescendingOrder;
    _sortPrices();
    notifyListeners();
  }

  void _sortPrices() {
    if (isDescendingOrder) {
      cropPrices.sort((a, b) => b.modalPrice.compareTo(a.modalPrice));
    } else {
      cropPrices.sort((a, b) => a.modalPrice.compareTo(b.modalPrice));
    }
  }

  CropPrice? get bestMarket {
    if (cropPrices.isEmpty) return null;
    return cropPrices.reduce((a, b) => a.modalPrice > b.modalPrice ? a : b);
  }
}
