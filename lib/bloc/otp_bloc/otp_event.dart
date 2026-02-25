import 'package:equatable/equatable.dart';

abstract class OtpEvent {}

class VerifyOtpEvent extends OtpEvent {
  final String mobile;
  final String otp;

  VerifyOtpEvent({
    required this.mobile,
    required this.otp,
  });
}