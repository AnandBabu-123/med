import '../../models/online_doctors_model/online_doctor_coupon_model.dart';

abstract class DoctorCouponEvent {}

class FetchDoctorCouponsEvent extends DoctorCouponEvent {
  final int specialityId;

  FetchDoctorCouponsEvent({required this.specialityId});
}

class ApplyDoctorCouponEvent extends DoctorCouponEvent {
  final Coupon coupon;
  final int doctorFee;

  ApplyDoctorCouponEvent({
    required this.coupon,
    required this.doctorFee,
  });
}