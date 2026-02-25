import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/otp_verify_request.dart';
import '../../repository/otp_respository/otp_repository.dart';
import '../../utils/session_manager.dart';
import 'otp_event.dart';
import 'otp_state.dart';



class OtpBloc extends Bloc<OtpEvent, OtpState> {

  final OtpRepository repository;

  OtpBloc(this.repository) : super(const OtpState()) {

    on<VerifyOtpEvent>(_verifyOtp);
  }

  Future<void> _verifyOtp(
      VerifyOtpEvent event,
      Emitter<OtpState> emit,
      ) async {

    try {

      print("EVENT RECEIVED IN BLOC");

      emit(state.copyWith(status: OtpStatus.loading));

      final response = await repository.verifyOtp(
        mobile: event.mobile,
        otp: event.otp,
      );

      /// ✅ SAVE USER DATA
      await SessionManager.saveUser(
        id: response.response.id,
        mobile: response.response.mobile,
        email: response.response.email,
        token: response.response.authToken,
      );

      print("USER SAVED SUCCESS");

      emit(state.copyWith(
        status: OtpStatus.success,
        message: response.message,
      ));

    } catch (e) {

      print("API ERROR => $e");

      emit(state.copyWith(
        status: OtpStatus.failure,
        message: e.toString(),
      ));
    }
  }
}