import 'api_response.dart';

abstract class BaseApiService {
  Future<ApiResponse> getApi(String url, {bool isAuthRequired = false});

  Future<ApiResponse> postApi(String url, dynamic data,
      {bool isAuthRequired = false});

  Future<ApiResponse> putApi(String url, dynamic data,
      {bool isAuthRequired = false});

  Future<ApiResponse> deleteApi(String url,
      {bool isAuthRequired = false});
}


