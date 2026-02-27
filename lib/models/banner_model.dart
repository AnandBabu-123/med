

class BannerModel {
  final int id;
  final String image;
  final String position;

  BannerModel({
    required this.id,
    required this.image,
    required this.position,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      image: json['image'] ?? '',
      position: json['position'] ?? '',
    );
  }

  /// ✅ FULL IMAGE URL
  String get imageUrl =>
      "https://medrayder.in/bharosa/$image";
}