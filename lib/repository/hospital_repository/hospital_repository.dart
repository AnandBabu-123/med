
import '../../config/routes/app_url.dart';
import '../../models/hospital_model/hospital_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class HospitalRepository {

  final DioClient dioClient;

  HospitalRepository(this.dioClient);

  Future<HospitalResponseModel> pharmacyOngoingOrders({
    required String language,
    required int page,
    required String lat,
    required String lon,
    String search = "",
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "cat_id": 1,
      "lat": lat,
      "lon": lon,
      "page": page,
      "search": search,
      "language": language,
    };

    final response = await dioClient.post(
      AppUrl.hospitalMainData,
      data: body,
    );

    print("===== HOSPITAL RESPONSE =====");
    print(response);

    return HospitalResponseModel.fromJson(response);
  }
}