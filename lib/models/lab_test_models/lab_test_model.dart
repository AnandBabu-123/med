class LabtestModel {
  final bool status;
  final String message;
  final LabtestResponse response;

  LabtestModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory LabtestModel.fromJson(Map<String, dynamic> json) {
    return LabtestModel(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      response:
      LabtestResponse.fromJson(json['response'] ?? {}),
    );
  }
}

/// ================= RESPONSE =================
class LabtestResponse {
  final List<LabMainData> mainData;
  final Pagination pagination;

  LabtestResponse({
    required this.mainData,
    required this.pagination,
  });

  factory LabtestResponse.fromJson(
      Map<String, dynamic> json) {
    return LabtestResponse(
      mainData: (json['main_data'] as List? ?? [])
          .map((e) => LabMainData.fromJson(e))
          .toList(),
      pagination:
      Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

/// ================= MAIN DATA =================
class LabMainData {
  final int id;
  final String name;
  final String logo;
  final String openTime;
  final String closeTime;
  final String location;
  final String lat;
  final String lon;

  LabMainData({
    required this.id,
    required this.name,
    required this.logo,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.lat,
    required this.lon,
  });

  factory LabMainData.fromJson(
      Map<String, dynamic> json) {
    return LabMainData(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      logo: json['logo'] ?? "",
      openTime: json['open_time'] ?? "",
      closeTime: json['close_time'] ?? "",
      location: json['location'] ?? "",
      lat: json['lat'] ?? "",
      lon: json['lon'] ?? "",
    );
  }
}

/// ================= PAGINATION =================
class Pagination {
  final List<int> totalPages;
  final int currentPage;
  final int limit;

  Pagination({
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(
      Map<String, dynamic> json) {
    return Pagination(
      totalPages: (json['total_pages'] as List? ?? [])
          .map((e) => e['page'] as int)
          .toList(),
      currentPage: json['current_page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}