import 'package:dio/dio.dart';

import '../../config/routes/app_url.dart';
import '../../models/profile_dropdown_model/profile_dropdown_model.dart';
import '../../models/profile_request_model/profile_request_model.dart';


import 'package:dio/dio.dart';

import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';



class ProfileRepository {

  final DioClient dioClient;

  ProfileRepository(this.dioClient);

  /// ================= DROPDOWNS =================

  Future<ProfileDropdownModel> fetchDropdowns({
    required int userId,
    required String token,
    required String language,
  }) async {

    final body = {
      "user_id": userId,
      "auth_token": token,
      "type": "gender/coverage_categories",
      "language": language
    };

    print("===== DROPDOWN REQUEST =====");
    print(body);

    final response = await dioClient.post(
      AppUrl.userDropdowns,
      data: body,
    );

    print("===== DROPDOWN RESPONSE =====");
    print(response);

    if (response == null) {
      throw Exception("Null response");
    }

    if (response["status"] == true) {
      return ProfileDropdownModel.fromJson(
        response["response"],
      );
    } else {
      throw Exception(response["message"]);
    }
  }

  /// ================= SUBMIT PROFILE =================

  Future<String> submitProfile(
      Map<String,dynamic> body
      ) async {

    print("===== PROFILE API BODY =====");
    print(body);

    final response = await dioClient.post(
      AppUrl.familyMembersCount,
      data: body,
    );

    print("===== PROFILE API RESPONSE =====");
    print(response);

    if (response == null) {
      throw Exception("Null API response");
    }

    if (response["status"] == true) {
      return response["message"];
    } else {
      throw Exception(response["message"]);
    }

  }
}