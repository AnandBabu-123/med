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

      print("========== OTP BLOC START ==========");

      /// ✅ EVENT DATA
      print("EVENT MOBILE => ${event.mobile}");
      print("EVENT OTP => ${event.otp}");

      emit(state.copyWith(status: OtpStatus.loading));

      /// ✅ API CALL
      print("CALLING VERIFY OTP API...");

      final response = await repository.verifyOtp(
        mobile: event.mobile,
        otp: event.otp,
      );

      print("✅ API SUCCESS RECEIVED");

      /// ✅ RAW RESPONSE DEBUG
      print("MESSAGE => ${response.message}");
      print("USER ID => ${response.response.id}");
      print("MOBILE => ${response.response.mobile}");
      print("EMAIL => ${response.response.email}");
      print("TOKEN => ${response.response.authToken}");

      /// ✅ SAVE USER DATA
      print("SAVING USER INTO SHARED PREFS...");

      await SessionManager.saveUser(
        id: response.response.id,
        mobile: response.response.mobile,
        email: response.response.email,
        token: response.response.authToken,
      );

      print("✅ USER SAVED SUCCESS");

      /// ✅ VERIFY SAVED DATA (VERY IMPORTANT)
      final savedId = await SessionManager.getUserId();
      final savedToken = await SessionManager.getToken();

      print("🔎 VERIFY PREF DATA");
      print("SAVED USER ID => $savedId");
      print("SAVED TOKEN => $savedToken");

      /// EXTRA FULL PREF PRINT
     // await SessionManager.printAllSession();

      print("========== OTP BLOC END ==========");

      emit(state.copyWith(
        status: OtpStatus.success,
        message: response.message,
      ));

    } catch (e, stacktrace) {

      print("❌ OTP API ERROR");
      print("ERROR => $e");
      print("STACKTRACE => $stacktrace");

      emit(state.copyWith(
        status: OtpStatus.failure,
        message: e.toString(),
      ));
    }
  }
}