class HospitalResponseModel {
  final bool status;
  final String message;
  final HospitalData? response;

  HospitalResponseModel({
    required this.status,
    required this.message,
    this.response,
  });

  factory HospitalResponseModel.fromJson(Map<String, dynamic> json) {
    return HospitalResponseModel(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      response: json["response"] != null
          ? HospitalData.fromJson(json["response"])
          : null,
    );
  }
}

class HospitalData {
  final List<Hospital> mainData;

  HospitalData({required this.mainData});

  factory HospitalData.fromJson(Map<String, dynamic> json) {
    return HospitalData(
      mainData: json["main_data"] == null
          ? []
          : List<Hospital>.from(
          json["main_data"].map((x) => Hospital.fromJson(x))),
    );
  }
}

class Hospital {
  final int id;
  final int catId;
  final int subCatId;
  final int subSubCatId;
  final String name;
  final String tagline;
  final String logo;
  final String openTime;
  final String closeTime;
  final String location;
  final double lat;
  final double lon;

  Hospital({
    required this.id,
    required this.catId,
    required this.subCatId,
    required this.subSubCatId,
    required this.name,
    required this.tagline,
    required this.logo,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.lat,
    required this.lon,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json["id"] ?? 0,
      catId: json["cat_id"] ?? 0,
      subCatId: json["sub_cat_id"] ?? 0,
      subSubCatId: json["sub_sub_cat_id"] ?? 0,
      name: json["name"] ?? "",
      tagline: json["tagline"] ?? "",
      logo: json["logo"] ?? "",
      openTime: json["open_time"] ?? "",
      closeTime: json["close_time"] ?? "",
      location: json["location"] ?? "",

      lat: double.tryParse(json["lat"].toString()) ?? 0.0,
      lon: double.tryParse(json["lon"].toString()) ?? 0.0,
    );
  }
}