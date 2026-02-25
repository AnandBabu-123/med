import 'package:equatable/equatable.dart';
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupOtpSent extends SignupState {
  final String otp;

  SignupOtpSent(this.otp);
}

class SignupError extends SignupState {
  final String message;

  SignupError(this.message);
}