class CropPrice {
  final String market;
  final String crop;
  final int minPrice;
  final int maxPrice;
  final int modalPrice;
  final double? latitude;
  final double? longitude;

  CropPrice({
    required this.market,
    required this.crop,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
    this.latitude,
    this.longitude,
  });

  factory CropPrice.fromJson(Map<String, dynamic> json) {
    return CropPrice(
      market: json['market'],
      crop: json['crop'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      modalPrice: json['modal_price'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
}
