import 'package:medryder/models/lab_test_models/lab_model.dart';
import 'package:medryder/models/lab_test_models/lab_test_model.dart';
import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class LabRepository {

  final DioClient dioClient;

  LabRepository(this.dioClient);

  Future<LabModel> LabTests({
    required int labTestId,
    required int page,
    required String language,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "lab_test_id": labTestId,
      "page": page,
      "language": language
    };

    final response = await dioClient.post(
      AppUrl.labList,
      data: body,
    );

    if (response["status"] == true) {
      return LabModel.fromJson(response);
    } else {
      throw Exception(response["message"]);
    }
  }
}