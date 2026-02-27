class PharmacyCategoryModel {
  final int id;
  final String name;
  final String image;

  PharmacyCategoryModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory PharmacyCategoryModel.fromJson(Map<String, dynamic> json) {
    return PharmacyCategoryModel(
      id: json["id"],
      name: json["name"],
      image: json["image"],
    );
  }
}