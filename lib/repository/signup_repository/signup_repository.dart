import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/login_request_model.dart';



class SignupRepository {

  Future<String> login(LoginRequestModel request) async {

    final response = await http.post(
      Uri.parse("https://medconnect.org.in/bharosa/app/ws/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(request.toJson()),
    );

    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {

      /// ✅ CORRECT PATH
      final otp = data["response"]["otp"].toString();

      return otp;
    } else {
      throw Exception(data["message"] ?? "Something went wrong");
    }
  }
}

// class SignupRepository {
//
//   Future<Map<String, dynamic>> login(
//       LoginRequestModel request) async {
//
//     final uri = Uri.parse(
//         "https://medconnect.org.in/bharosa/app/ws/login"); // ✅ put real API
//
//     final response = await http.post(
//       uri,
//       headers: {
//         "Content-Type": "application/json",
//         "Accept": "application/json",
//       },
//       body: jsonEncode(request.toJson()),
//     );
//
//     print("STATUS => ${response.statusCode}");
//     print("BODY => ${response.body}");
//
//     final data = jsonDecode(response.body);
//
//     /// same as Android:
//     /// if(response.status) -> success
//     if (response.statusCode == 200 && data["status"] == true) {
//       return data;
//     } else {
//       throw Exception(data["message"] ?? "OTP Failed");
//     }
//   }
// }