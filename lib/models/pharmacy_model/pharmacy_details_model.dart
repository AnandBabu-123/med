class PharmacyDetailsModel {
  final bool status;
  final String message;
  final PharmacyData data;

  PharmacyDetailsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PharmacyDetailsModel.fromJson(Map<String, dynamic> json) {
    return PharmacyDetailsModel(
      status: json["status"],
      message: json["message"],
      data: PharmacyData.fromJson(json["response"]["main_data"]),
    );
  }
}

class PharmacyData {
  final int id;
  final String name;
  final String mobile;
  final String logo;
  final String openTime;
  final String closeTime;
  final String location;
  final String homeDelivery;
  final List<PharmacyImage> images;
  final List<PharmacyCategory> categories;

  PharmacyData({
    required this.id,
    required this.name,
    required this.mobile,
    required this.logo,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.homeDelivery,
    required this.images,
    required this.categories,
  });

  factory PharmacyData.fromJson(Map<String, dynamic> json) {
    return PharmacyData(
      id: json["id"],
      name: json["name"],
      mobile: json["mobile"].toString(),
      logo: json["logo"],
      openTime: json["open_time"],
      closeTime: json["close_time"],
      location: json["location"],
      homeDelivery: json["home_delivery"],
      images: (json["images"] as List)
          .map((e) => PharmacyImage.fromJson(e))
          .toList(),
      categories: (json["pharmacy_categories"] as List)
          .map((e) => PharmacyCategory.fromJson(e))
          .toList(),
    );
  }
}

class PharmacyImage {
  final String url;

  PharmacyImage({required this.url});

  factory PharmacyImage.fromJson(Map<String, dynamic> json) {
    return PharmacyImage(url: json["url"]);
  }
}

class PharmacyCategory {
  final int id;
  final String name;
  final String image;

  PharmacyCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory PharmacyCategory.fromJson(Map<String, dynamic> json) {
    return PharmacyCategory(
      id: json["id"],
      name: json["name"],
      image: json["image"],
    );
  }
}