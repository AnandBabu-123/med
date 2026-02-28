class DiagnosticsResponse {
  final bool status;
  final String message;
  final List<Diagnostic> mainData;
  final Pagination pagination;

  DiagnosticsResponse({
    required this.status,
    required this.message,
    required this.mainData,
    required this.pagination,
  });

  factory DiagnosticsResponse.fromJson(Map<String, dynamic> json) {
    final response = json['response'];

    return DiagnosticsResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",

      mainData: (response['main_data'] as List? ?? [])
          .map((e) => Diagnostic.fromJson(e))
          .toList(),

      pagination: Pagination.fromJson(response['pagination'] ?? {}),
    );
  }
}
class Diagnostic {
  final int id;
  final String name;
  final String logo;
  final String openTime;
  final String closeTime;
  final String location;
  final String lat;
  final String lon;

  Diagnostic({
    required this.id,
    required this.name,
    required this.logo,
    required this.openTime,
    required this.closeTime,
    required this.location,
    required this.lat,
    required this.lon,
  });

  factory Diagnostic.fromJson(Map<String, dynamic> json) {
    return Diagnostic(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      logo: json['logo'] ?? "",
      openTime: json['open_time'] ?? "",
      closeTime: json['close_time'] ?? "",
      location: json['location'] ?? "",
      lat: json['lat'].toString(),
      lon: json['lon'].toString(),
    );
  }
}
class Pagination {
  final int currentPage;
  final int totalPages;
  final int limit;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.limit,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {

    /// API FORMAT:
    /// total_pages: [{page: 1}]
    final List pagesList = json['total_pages'] ?? [];

    int total = 1;

    if (pagesList.isNotEmpty) {
      total = pagesList.first['page'] ?? 1;
    }

    return Pagination(
      currentPage: json['current_page'] ?? 1,
      totalPages: total,
      limit: json['limit'] ?? 10,
    );
  }
}