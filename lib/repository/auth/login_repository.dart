

import '../../config/app_urls.dart';
import '../../models/login/login_model.dart';
import '../../network/api_response.dart';
import '../../network/network_api_service.dart';

class LoginRepository {
  final _api = NetworkApiService();

  Future<ApiResponse> loginApi(dynamic data) async {
    return await _api.postApi(AppUrls.loginApi, data);
  }
}
