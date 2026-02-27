import 'dart:async';
import '../config/app_urls.dart';
import '../data/app_exceptions.dart';
import '../utils/session_manager.dart';
import 'api_response.dart';
import 'base_api_service.dart';
import 'package:dio/dio.dart';



class NetworkApiService implements BaseApiService {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppUrls.baseUrl,
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      sendTimeout: const Duration(seconds: 50),
      responseType: ResponseType.json,
      headers: {
        "Accept": "application/json",
      },
    ),
  );

  /// ================= COMMON HEADER =================
  Future<Options> _options({
    bool isAuthRequired = false,
    bool isMultipart = false,
  }) async {

    final headers = <String, dynamic>{
      "Accept": "application/json",
    };

    /// ✅ TOKEN AUTO ATTACH
    if (isAuthRequired) {
      final token = await SessionManager.getToken();

      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    /// ✅ CONTENT TYPE SWITCH
    headers["Content-Type"] =
    isMultipart ? "multipart/form-data" : "application/json";

    return Options(headers: headers);
  }

  // ================= GET =================
  @override
  Future<ApiResponse> getApi(
      String url, {
        bool isAuthRequired = false,
      }) async {
    try {

      final response = await _dio.get(
        url,
        options: await _options(isAuthRequired: isAuthRequired),
      );

      return _processResponse(response);

    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= POST =================
  @override
  Future<ApiResponse> postApi(
      String url,
      dynamic data, {
        bool isAuthRequired = false,
      }) async {

    try {

      final response = await _dio.post(
        url,
        data: data,
        options: await _options(
          isAuthRequired: isAuthRequired,
          isMultipart: data is FormData,
        ),
      );

      return _processResponse(response);

    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= PUT =================
  @override
  Future<ApiResponse> putApi(
      String url,
      dynamic data, {
        bool isAuthRequired = false,
      }) async {

    try {

      final response = await _dio.put(
        url,
        data: data,
        options: await _options(
          isAuthRequired: isAuthRequired,
          isMultipart: data is FormData,
        ),
      );

      return _processResponse(response);

    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= DELETE =================
  @override
  Future<ApiResponse> deleteApi(
      String url, {
        bool isAuthRequired = false,
      }) async {

    try {

      final response = await _dio.delete(
        url,
        options: await _options(isAuthRequired: isAuthRequired),
      );

      return _processResponse(response);

    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= RESPONSE =================
  ApiResponse _processResponse(Response response) {

    final data = response.data;

    return ApiResponse(
      statusCode: response.statusCode ?? 0,
      data: data is String ? {"message": data} : data,
    );
  }

  // ================= ERROR =================
  Exception _handleDioError(DioException error) {

    switch (error.type) {

      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return FetchDataException("Request Timeout");

      case DioExceptionType.connectionError:
        return NoInternetException("No Internet Connection");

      case DioExceptionType.badResponse:

        final statusCode = error.response?.statusCode ?? 0;
        final message =
            error.response?.data?["message"] ?? "Something went wrong";

        if (statusCode == 400) {
          return BadRequestException(message);
        } else if (statusCode == 401 || statusCode == 403) {
          return UnauthorizedException(message);
        } else if (statusCode >= 500) {
          return ServerException("Server Error");
        }

        return FetchDataException(message);

      case DioExceptionType.cancel:
        return FetchDataException("Request Cancelled");

      default:
        return FetchDataException("Unexpected Error");
    }
  }
}



