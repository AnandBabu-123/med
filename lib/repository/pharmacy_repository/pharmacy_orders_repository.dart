
import '../../config/routes/app_url.dart';
import '../../models/pharmacy_model/pharmacy_ongoing_orders_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class PharmacyOrdersRepository {

  final DioClient dioClient;

  PharmacyOrdersRepository(this.dioClient);

  Future<PharmacyOngoingOrdersModel> pharmacyOngoingOrders({
    required String language,
    required int page,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "page": page,
      "language": language,
    };

    final response = await dioClient.post(
      AppUrl.pharmacyOngoingOrders,
      data: body,
    );

    print("===== PHARMACY ORDERS RESPONSE =====");
    print(response);

    return PharmacyOngoingOrdersModel.fromJson(response);
  }
}