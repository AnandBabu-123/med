import 'dart:io';
import 'package:dio/dio.dart';
import 'api_exception.dart';
import 'network_info.dart';

class DioClient {
  final Dio dio;
  final NetworkInfo networkInfo;

  DioClient({
    required this.dio,
    required this.networkInfo,
  }) {
    dio.options = BaseOptions(
      baseUrl: "https://medconnect.org.in/bharosa/app/ws/",
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        "Content-Type": "application/json",
      },
    );
  }

  /// ================= GET =================
  Future<dynamic> get(String url,
      {Map<String, dynamic>? query}) async {
    if (!await networkInfo.isConnected) {
      throw ApiException("No Internet Connection");
    }

    try {
      final response = await dio.get(url, queryParameters: query);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on SocketException {
      throw ApiException("Network Error");
    } catch (e) {
      throw ApiException("Something went wrong");
    }
  }

  /// ================= POST =================
  Future<dynamic> post(String url,
      {dynamic data}) async {
    if (!await networkInfo.isConnected) {
      throw ApiException("No Internet Connection");
    }

    try {
      final response = await dio.post(url, data: data);
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (_) {
      throw ApiException("Unexpected Error");
    }
  }

  /// ================= RESPONSE =================
  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      return response.data;
    } else {
      throw ApiException(
          response.data["message"] ?? "Server Error");
    }
  }

  /// ================= ERROR HANDLER =================
  ApiException _handleDioError(DioException e) {

    if (e.error is SocketException) {
      return ApiException("No Internet Connection");
    }

    switch (e.type) {

      case DioExceptionType.connectionTimeout:
        return ApiException("Connection Timeout");

      case DioExceptionType.sendTimeout:
        return ApiException("Send Timeout");

      case DioExceptionType.receiveTimeout:
        return ApiException("Receive Timeout");

      case DioExceptionType.badCertificate:
        return ApiException("SSL Certificate Error");

      case DioExceptionType.badResponse:
        return ApiException(
          e.response?.data?["message"] ?? "Server Error",
        );

      case DioExceptionType.cancel:
        return ApiException("Request Cancelled");

      case DioExceptionType.connectionError:
        return ApiException("No Internet Connection");

      case DioExceptionType.unknown:
        return ApiException("Something went wrong");
    }
  }
}