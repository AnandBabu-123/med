
import '../../config/routes/app_url.dart';
import '../../models/pharmacy_model/pharmacy_details_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class PharmacyDetailsRepository {

  final DioClient dioClient;

  PharmacyDetailsRepository(this.dioClient);

  Future<PharmacyDetailsModel> getPharmacyDetails({
    required int mainDataId,
    required String language,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "main_data_id": mainDataId,
      "language": language,
    };

    final response = await dioClient.post(
      AppUrl.pharmacyDetailsCategories,
      data: body,
    );

    print("===== PHARMACY DETAILS RESPONSE =====");
    print(response);

    return PharmacyDetailsModel.fromJson(response);
  }
}