import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repository/online_doctors_repository/online_doctor_coupon_repository.dart';
import 'doctor_coupon_event.dart';
import 'doctor_coupon_state.dart';

class DoctorCouponBloc
    extends Bloc<DoctorCouponEvent, DoctorCouponState> {

  final OnlineDoctorCouponRepository repository;

  DoctorCouponBloc(this.repository)
      : super(DoctorCouponState()) {

    on<FetchDoctorCouponsEvent>(_fetchCoupons);
    on<ApplyDoctorCouponEvent>(_applyCoupon);
  }

  Future<void> _fetchCoupons(
      FetchDoctorCouponsEvent event,
      Emitter<DoctorCouponState> emit,
      ) async {

    emit(state.copyWith(isLoading: true));

    final response = await repository.onlineDoctorCoupon(
      language: "en",
      specialityId: event.specialityId,
      page: 1,
    );

    emit(
      state.copyWith(
        isLoading: false,
        coupons: response.coupons,
      ),
    );
  }

  void _applyCoupon(
      ApplyDoctorCouponEvent event,
      Emitter<DoctorCouponState> emit,
      ) {

    final discount =
        event.doctorFee * event.coupon.percentage / 100;

    final total = event.doctorFee - discount;

    emit(
      state.copyWith(
        selectedCoupon: event.coupon,
        totalPrice: total,
      ),
    );
  }
}