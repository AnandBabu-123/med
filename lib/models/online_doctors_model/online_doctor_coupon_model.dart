class OnlineDoctorCouponResponse {
  final bool status;
  final String message;
  final List<Coupon> coupons;

  OnlineDoctorCouponResponse({
    required this.status,
    required this.message,
    required this.coupons,
  });

  factory OnlineDoctorCouponResponse.fromJson(Map<String, dynamic> json) {
    return OnlineDoctorCouponResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? "",
      coupons: (json['response']?['coupons'] as List? ?? [])
          .map((e) => Coupon.fromJson(e))
          .toList(),
    );
  }
}

class Coupon {
  final int id;
  final String name;
  final int percentage;
  final String description;

  Coupon({
    required this.id,
    required this.name,
    required this.percentage,
    required this.description,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      percentage: json['percentage'] ?? 0,
      description: json['description'] ?? "",
    );
  }
}