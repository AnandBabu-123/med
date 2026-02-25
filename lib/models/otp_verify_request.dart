class OtpVerifyRequest {
  final String mobile;
  final String referralCode;
  final String otpStatus;
  final String playerId;
  final String deviceToken;

  OtpVerifyRequest({
    required this.mobile,
    required this.referralCode,
    required this.otpStatus,
    required this.playerId,
    required this.deviceToken,
  });

  Map<String, dynamic> toJson() {
    return {
      "mobile": mobile,
      "referral_code": referralCode,
      "otp_status": otpStatus,
      "player_id": playerId,
      "device_token": deviceToken,
    };
  }
}