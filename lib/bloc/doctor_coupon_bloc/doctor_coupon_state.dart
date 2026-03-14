import '../../models/online_doctors_model/online_doctor_coupon_model.dart';

class DoctorCouponState {

  final bool isLoading;
  final List<Coupon> coupons;
  final Coupon? selectedCoupon;
  final double totalPrice;

  DoctorCouponState({
    this.isLoading = false,
    this.coupons = const [],
    this.selectedCoupon,
    this.totalPrice = 0,
  });

  DoctorCouponState copyWith({
    bool? isLoading,
    List<Coupon>? coupons,
    Coupon? selectedCoupon,
    double? totalPrice,
  }) {
    return DoctorCouponState(
      isLoading: isLoading ?? this.isLoading,
      coupons: coupons ?? this.coupons,
      selectedCoupon: selectedCoupon ?? this.selectedCoupon,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }
}