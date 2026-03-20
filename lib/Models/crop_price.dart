class CropPrice {
  final String market;
  final String crop;
  final int minPrice;
  final int maxPrice;
  final int modalPrice;

  CropPrice({
    required this.market,
    required this.crop,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  factory CropPrice.fromJson(Map<String, dynamic> json) {
    return CropPrice(
      market: json['market'],
      crop: json['crop'],
      minPrice: json['min_price'],
      maxPrice: json['max_price'],
      modalPrice: json['modal_price'],
    );
  }
}
