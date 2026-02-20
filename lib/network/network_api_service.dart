import 'dart:async';
import '../data/app_exceptions.dart';
import '../utils/session_manager.dart';
import 'api_response.dart';
import 'base_api_service.dart';
import 'package:dio/dio.dart';

class NetworkApiService implements BaseApiService {
  final Dio _dio = Dio();
  final SessionManager _session = SessionManager();

  NetworkApiService() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 50),
      receiveTimeout: const Duration(seconds: 50),
      sendTimeout: const Duration(seconds: 50),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );
  }

  /// 🔹 COMMON HEADER BUILDER
  Future<Options> _options({bool isAuthRequired = false}) async {
    Map<String, dynamic> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };

    if (isAuthRequired) {
      final token = await _session.getToken();
      if (token != null && token.isNotEmpty) {
        headers["Authorization"] = "Bearer $token";
      }
    }

    return Options(headers: headers);
  }

  // ================= GET =================
  @override
  Future<ApiResponse> getApi(String url,
      {bool isAuthRequired = false}) async {
    try {
      final response =
      await _dio.get(url, options: await _options(isAuthRequired: isAuthRequired));

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= POST =================
  @override
  Future<ApiResponse> postApi(String url, dynamic data,
      {bool isAuthRequired = false}) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        options: await _options(isAuthRequired: isAuthRequired),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= PUT =================
  @override
  Future<ApiResponse> putApi(String url, dynamic data,
      {bool isAuthRequired = false}) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        options: await _options(isAuthRequired: isAuthRequired),
      );

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= DELETE =================
  @override
  Future<ApiResponse> deleteApi(String url,
      {bool isAuthRequired = false}) async {
    try {
      final response =
      await _dio.delete(url, options: await _options(isAuthRequired: isAuthRequired));

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ================= RESPONSE HANDLER =================
  ApiResponse _processResponse(Response response) {
    return ApiResponse(
      statusCode: response.statusCode ?? 0,
      data: response.data,
    );
  }

  // ================= ERROR HANDLER =================
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



