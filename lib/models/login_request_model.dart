class LoginRequestModel {
  final String mobile;
  final String otpStatus;
  final String playerId;
  final String referralCode;

  LoginRequestModel({
    required this.mobile,
    required this.otpStatus,
    required this.playerId,
    required this.referralCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile,
      "otp_status": otpStatus,
      "player_id": playerId,
      "referral_code": referralCode,
    };
  }
}