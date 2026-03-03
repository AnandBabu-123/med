import '../../config/routes/app_url.dart';
import '../../models/login_response_model.dart';
import '../../network/dio_network/dio_client.dart';


class OtpRepository {

  final DioClient dioClient;

  OtpRepository(this.dioClient);

  Future<LoginResponseModel> verifyOtp({
    required String mobile,
    required String otp,
  }) async {

    final response = await dioClient.post(
      AppUrl.login,
      data: {
        "mobile": mobile,
        "otp": otp,
        "otp_status": "verified",
        "player_id": "player_id",
        "device_token": "device_token",
        "referral_code": ""
      },
    );

   // print("OTP RESPONSE => $response");

    /// response already decoded by Dio
    if (response["status"] == true) {
      return LoginResponseModel.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "OTP Failed");
    }
  }
}
