import 'dart:convert';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/login_response_model.dart';
import '../../models/otp_verify_request.dart';



class OtpRepository {

  Future<LoginResponseModel> verifyOtp({
    required String mobile,
    required String otp,
  }) async {

    final response = await http.post(
      Uri.parse("https://medconnect.org.in/bharosa/app/ws/login"),

      headers: {
        "Content-Type": "application/json",
      },

      body: jsonEncode({
        "mobile": mobile,
        "otp": otp,
        "otp_status": "verified",
        "player_id": "player_id",
        "device_token": "device_token",
        "referral_code": ""
      }),
    );

    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {
      return LoginResponseModel.fromJson(data);
    } else {
      throw Exception(data["message"]);
    }
  }
}