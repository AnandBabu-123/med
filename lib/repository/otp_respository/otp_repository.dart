import 'dart:convert';
import 'package:http/http.dart' as http;
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

    print("OTP RESPONSE => $response");

    /// response already decoded by Dio
    if (response["status"] == true) {
      return LoginResponseModel.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "OTP Failed");
    }
  }
}

// class OtpRepository {
//
//   Future<LoginResponseModel> verifyOtp({
//     required String mobile,
//     required String otp,
//   }) async {
//
//     final response = await http.post(
//       Uri.parse("https://medconnect.org.in/bharosa/app/ws/login"),
//
//       headers: {
//         "Content-Type": "application/json",
//       },
//
//       body: jsonEncode({
//         "mobile": mobile,
//         "otp": otp,
//         "otp_status": "verified",
//         "player_id": "player_id",
//         "device_token": "device_token",
//         "referral_code": ""
//       }),
//     );
//
//     print("STATUS => ${response.statusCode}");
//     print("BODY => ${response.body}");
//
//     final data = jsonDecode(response.body);
//
//     if (response.statusCode == 200 && data["status"] == true) {
//       return LoginResponseModel.fromJson(data);
//     } else {
//       throw Exception(data["message"]);
//     }
//   }
// }