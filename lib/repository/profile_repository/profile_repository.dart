
import '../../config/app_urls.dart';
import '../../models/profile_request_model.dart';
import '../../network/base_api_service.dart';
import '../../network/network_api_service.dart';
import 'dart:io';

class ProfileRepository {

  final BaseApiService apiService = NetworkApiService();

  Future<Map<String, dynamic>> updateProfile(
      ProfileRequestModel request,
      File? imageFile,
      ) async {

    print("========== PROFILE UPDATE DEBUG ==========");

    /// ✅ Directly use model json
    final body = request.toJson();

    print("REQUEST BODY => $body");

    final response = await apiService.postApi(
      AppUrls.updateProfile,
      body,
      isAuthRequired: true,
    );

    print("API RESPONSE => ${response.data}");

    return response.data;
  }
}

