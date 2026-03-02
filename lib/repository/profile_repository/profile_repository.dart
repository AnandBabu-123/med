//
// import 'package:http/http.dart' as dioClient;
//
// import '../../config/routes/app_url.dart';
// import '../../models/profile_request_model.dart';
// import 'dart:io';
//
// class ProfileRepository {
//
// //  final BaseApiService apiService = NetworkApiService();
//
//   Future<Map<String, dynamic>> updateProfile(
//       ProfileRequestModel request,
//       File? imageFile,
//       ) async {
//
//     print("========== PROFILE UPDATE DEBUG ==========");
//
//     /// ✅ Directly use model json
//     final body = request.toJson();
//
//     print("REQUEST BODY => $body");
//
//
//     final response = await dioClient.post(
//       AppUrl.updateProfile,
//       body,
//       isAuthRequired: true,
//     );
//
//
//     print("API RESPONSE => ${response.data}");
//
//     return response.data;
//   }
// }
//
