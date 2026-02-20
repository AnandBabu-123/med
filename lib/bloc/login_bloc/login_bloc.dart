import 'dart:ffi';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import '../../models/login/login_model.dart';
import '../../repository/auth/login_repository.dart';
import '../../utils/enums.dart';
import '../../utils/session_manager.dart';

part 'login_event.dart';
part 'login_states.dart';


class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  final LoginRepository loginRepository = LoginRepository();
  final SessionManager sessionManager = SessionManager();


  LoginBloc() : super(const LoginStates()) {
    on<EmailChange>(_onEmailChange);
    on<PasswordChange>(_onPasswordChange);
    on<LoginApi>(_loginApi);
  }

  void _onEmailChange(EmailChange event, Emitter<LoginStates> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChange(PasswordChange event, Emitter<LoginStates> emit) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _loginApi(LoginApi event, Emitter<LoginStates> emit) async {
    emit(state.copyWith(
      postApiStatus: PostApiStatus.loading,
      message: '',
    ));

    try {
      final data = {
        "email": state.email,
        "password": state.password,
      };

      final apiResponse = await loginRepository.loginApi(data);

      print("STATUS CODE: ${apiResponse.statusCode}");

      // 🔥 SUCCESS (200)
      if (apiResponse.statusCode == 200) {
        final response = LoginModel.fromJson(apiResponse.data);
        await sessionManager.saveUser(response);
        emit(state.copyWith(
          postApiStatus: PostApiStatus.success,
          message: response.responseMessage ?? "Login Success",
        //  userId: response.userId,
        ));
      }

      // 🔥 CLIENT ERROR (400)
      else if (apiResponse.statusCode == 400) {
        final response = LoginModel.fromJson(apiResponse.data);

        emit(state.copyWith(
          postApiStatus: PostApiStatus.failure,
          message: response.responseMessage ?? "Invalid Credentials",
        ));
      }

      // 🔥 UNAUTHORIZED (401)
      else if (apiResponse.statusCode == 401) {
        emit(state.copyWith(
          postApiStatus: PostApiStatus.failure,
          message: "Unauthorized user",
        ));
      }

      // 🔥 OTHER ERRORS
      else {
        emit(state.copyWith(
          postApiStatus: PostApiStatus.failure,
          message: "Server Error ${apiResponse.statusCode}",
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        postApiStatus: PostApiStatus.failure,
        message: e.toString(),
      ));
    }
  }
}


