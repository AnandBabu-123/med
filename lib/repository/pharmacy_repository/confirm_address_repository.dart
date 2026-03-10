import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class ConfirmAddressRepository {

  final DioClient dioClient;

  ConfirmAddressRepository(this.dioClient);

  Future<dynamic> getPharmacies({

    required int userId,
    required String token,
    required int pharmacyId,
    required String image,
    required String orderType,
    required int addressId,
    required String name,
    required String mobile,
    required String language,

  }) async {

    final body = {

      "user_id": userId,
      "auth_token": token,
      "view_type": "order",
      "pharmacy_id": pharmacyId,
      "image": image,
      "order_type": orderType,
      "address_id": addressId,
      "name": name,
      "mobile": mobile,
      "language": language,
    };

    print("===== CONFIRM ORDER BODY =====");
    print(body);

    final response = await dioClient.post(
      AppUrl.confirmDetailsCategories,
      data: body,
    );

    print("===== CONFIRM ORDER RESPONSE =====");
    print(response);

    return response;
  }
}