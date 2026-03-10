class PharmacyResponseModel {

  final bool status;
  final String message;
  final PharmacyData response;

  PharmacyResponseModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory PharmacyResponseModel.fromJson(Map<String, dynamic> json) {
    return PharmacyResponseModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      response: PharmacyData.fromJson(json["response"] ?? {}),
    );
  }
}

class PharmacyData {

  final List<PharmacyModel> mainData;

  PharmacyData({required this.mainData});

  factory PharmacyData.fromJson(Map<String, dynamic> json) {

    final list = json["main_data"] as List? ?? [];

    return PharmacyData(
      mainData: list.map((e) => PharmacyModel.fromJson(e)).toList(),
    );
  }
}

class PharmacyModel {

  final int id;
  final String name;
  final String logo;
  final String openTime;
  final String closeTime;
  final String location;
  final double lat;
  final double lon;
  final String homeDelivery;

  PharmacyModel({
    required this.id,
    required this.name,
    required this.logo,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.lat,
    required this.lon,
    required this.homeDelivery,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {

    return PharmacyModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      logo: json["logo"] ?? "",
      openTime: json["open_time"] ?? "",
      closeTime: json["close_time"] ?? "",
      location: json["location"] ?? "",
      lat: double.tryParse(json["lat"].toString()) ?? 0,
      lon: double.tryParse(json["lon"].toString()) ?? 0,
      homeDelivery: json["home_delivery"] ?? "",
    );
  }
}