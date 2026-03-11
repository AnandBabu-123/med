class ApplyFilterModel {
  final bool status;
  final String message;
  final ApplyFilterResponse response;

  ApplyFilterModel({
    required this.status,
    required this.message,
    required this.response,
  });

  factory ApplyFilterModel.fromJson(Map<String, dynamic> json) {
    return ApplyFilterModel(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      response: ApplyFilterResponse.fromJson(json['response'] ?? {}),
    );
  }
}

class ApplyFilterResponse {
  final List<HospitalData> mainData;
  final Pagination pagination;

  ApplyFilterResponse({
    required this.mainData,
    required this.pagination,
  });

  factory ApplyFilterResponse.fromJson(Map<String, dynamic> json) {
    return ApplyFilterResponse(
      mainData: (json['main_data'] as List? ?? [])
          .map((e) => HospitalData.fromJson(e))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] ?? {}),
    );
  }
}

class HospitalData {
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

  HospitalData({
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

  factory HospitalData.fromJson(Map<String, dynamic> json) {
    return HospitalData(
      id: json['id'] ?? 0,
      catId: json['cat_id'] ?? 0,
      subCatId: json['sub_cat_id'] ?? 0,
      subSubCatId: json['sub_sub_cat_id'] ?? 0,
      name: json['name'] ?? "",
      tagline: json['tagline'] ?? "",
      logo: json['logo'] ?? "",
      openTime: json['open_time'] ?? "",
      closeTime: json['close_time'] ?? "",
      location: json['location'] ?? "",

      /// SAFE PARSING
      lat: double.tryParse(json['lat'].toString()) ?? 0.0,
      lon: double.tryParse(json['lon'].toString()) ?? 0.0,
    );
  }
}

class Pagination {
  final List<TotalPages> totalPages;
  final int currentPage;
  final int limit;

  Pagination({
    required this.totalPages,
    required this.currentPage,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalPages: (json['total_pages'] as List? ?? [])
          .map((e) => TotalPages.fromJson(e))
          .toList(),
      currentPage: json['current_page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}

class TotalPages {
  final int page;

  TotalPages({required this.page});

  factory TotalPages.fromJson(Map<String, dynamic> json) {
    return TotalPages(
      page: json['page'] ?? 1,
    );
  }
}

