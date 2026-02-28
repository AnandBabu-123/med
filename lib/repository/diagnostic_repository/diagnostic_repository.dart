import '../../config/routes/app_url.dart';
import '../../models/diagnostic_model/diagnostic_response.dart';
import '../../models/get_address/get_address_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class GetDiagnosticRepository {
  final DioClient dioClient;

  GetDiagnosticRepository(this.dioClient);

  Future<DiagnosticsResponse> getDiagnostics({
    required String lat,
    required String lon,
    required String language,
    required int page,
    required String search,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "lat": lat,
      "lon": lon,
      "page": page,
      "search": search,
      "language": language,
    };

    print("===== DIAGNOSTIC REQUEST =====");
    print(body);

    final response = await dioClient.post(
      AppUrl.getDiagnostic,
      data: body,
    );

    print("===== DIAGNOSTIC RESPONSE =====");
    print(response);

    /// ✅ SAFETY CHECK
    if (response == null) {
      throw Exception("Null API response");
    }

    if (response["status"] == true) {
      return DiagnosticsResponse.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "API Failed");
    }
  }
}