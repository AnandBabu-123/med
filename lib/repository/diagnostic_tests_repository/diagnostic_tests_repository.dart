import 'package:dio/dio.dart';

import '../../config/routes/app_url.dart';
import '../../models/diagnostic_test_model/diagnostic_test_model.dart';

import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';


class DiagnosticTestsRepository {

  final DioClient dioClient;

  DiagnosticTestsRepository(this.dioClient);

  Future<List<TestMainData>> getDiagnosticTests({
    required int diagnosticId,
    required int page,
    required String language,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId.toString(),
      "auth_token": token,
      "diagnostic_id": diagnosticId,
      "page": page,
      "language": language,
    };

    /// DEBUG REQUEST
    print("===== DIAGNOSTIC TESTS REQUEST =====");
    print(body);

    final response = await dioClient.post(
      AppUrl.diagnosticTests,
      data: body,
    );

    /// DEBUG RESPONSE
    print("===== DIAGNOSTIC TESTS RESPONSE =====");
    print(response);

    if (response["status"] == true) {

      final model = DiagnosticTestsModel.fromJson(response);

      return model.response.mainData;

    } else {

      throw Exception(response["message"]);

    }
  }
}