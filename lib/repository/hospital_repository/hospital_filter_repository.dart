
import 'package:medryder/models/hospital_model/hospital_filter_model.dart';

import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class HospitalFilterRepository {

  final DioClient dioClient;

  HospitalFilterRepository(this.dioClient);

  Future<HospitalFilterModel> hospitalFilterData({
    required String language,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "cat_id": 1,
      "language": language,
    };

    final response = await dioClient.post(
      AppUrl.hospitalFilter,
      data: body,
    );

    print("===== HOSPITAL FILTER RESPONSE =====");
    print(response);

    return HospitalFilterModel.fromJson(response);
  }
}