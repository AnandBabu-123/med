import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/signup_repository/signup_repository.dart';
import 'signup_event.dart';
import 'signup_state.dart';
import '../../models/login_request_model.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {

  final SignupRepository repository;

  SignupBloc(this.repository) : super(SignupInitial()) {

    on<SendOtpEvent>((event, emit) async {

      emit(SignupLoading());

      try {

        final otp = await repository.login(
          LoginRequestModel(
            mobile: event.mobile,
            otpStatus: "not_verified",
            playerId: event.playerId,
            referralCode: event.referral,
          ),
        );

        /// ✅ OTP SUCCESS
        emit(SignupOtpSent(otp));

      } catch (e) {
        emit(SignupError(e.toString()));
      }
    });
  }
}