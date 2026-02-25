import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

abstract class SignupEvent {}

class SendOtpEvent extends SignupEvent {
  final String mobile;
  final String referral;
  final String playerId;

  SendOtpEvent({
    required this.mobile,
    required this.referral,
    required this.playerId,
  });
}