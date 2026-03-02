import 'package:medryder/models/lab_test_models/lab_test_model.dart';
import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class LabTestRepository {
  final DioClient dioClient;

  LabTestRepository(this.dioClient);

  Future<LabtestModel> getLabTest({
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
      AppUrl.labTest,
      data: body,
    );

    print("===== DIAGNOSTIC RESPONSE =====");
    print(response);

    /// ✅ SAFETY CHECK
    if (response == null) {
      throw Exception("Null API response");
    }

    if (response["status"] == true) {
      return LabtestModel.fromJson(response);
    } else {
      throw Exception(response["message"] ?? "API Failed");
    }
  }
}