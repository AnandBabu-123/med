import '../../config/routes/app_url.dart';
import '../../models/get_address/get_address_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class GetAddressRepository {
  final DioClient dioClient;

  GetAddressRepository(this.dioClient);

  Future<List<AddressItem>> getAddresses() async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId.toString(),
      "auth_token": token,
    };

    /// DEBUG REQUEST
    print("===== GET ADDRESS REQUEST =====");
    print(body);

    final response = await dioClient.post(
      AppUrl.getAddress,
      data: body,
    );

    print("===== GET ADDRESS RESPONSE =====");
    print(response);

    if (response["status"] == true) {
      final model = GetAddressModel.fromJson(response);
      return model.response.address;
    } else {
      throw Exception(response["message"]);
    }
  }
}