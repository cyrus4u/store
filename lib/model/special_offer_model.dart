class SpecialOfferModel {
  final int id;
  final String productName;
  final int price;
  final int offPrice;
  final int offPercent;
  final String imageUrl; // 👈 add this to show images

  SpecialOfferModel(
    this.id,
    this.productName,
    this.price,
    this.offPrice,
    this.offPercent,
    this.imageUrl,
  );

  // ✅ Factory constructor for easy JSON parsing
  factory SpecialOfferModel.fromJson(Map<String, dynamic> json) {
    return SpecialOfferModel(
      json['id'] ?? 0,
      json['product_name'] ?? '',
      json['price'] ?? 0,
      json['off_price'] ?? 0,
      json['off_percent'] ?? 0,
      json['image_url'] ?? '', // match your Supabase column name
    );
  }
}
