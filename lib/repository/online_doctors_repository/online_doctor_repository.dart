import 'package:medryder/models/online_doctors_model/online_doctors_model.dart';

import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class OnlineDoctorRepository {

  final DioClient dioClient;

  OnlineDoctorRepository(this.dioClient);

  Future<OnlineDoctorsModel> onlineDoctors({
    required String language,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "language": language,
    };

    final response = await dioClient.post(
      AppUrl.onlineDoctors,
      data: body,
    );
        print("${response}");
    /// response is already Map<String,dynamic>
    return OnlineDoctorsModel.fromJson(response);
  }
}