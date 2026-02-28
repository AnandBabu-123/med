
import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';


class PostAddressRepository {

  final DioClient dioClient;

  PostAddressRepository(this.dioClient);

  Future<String> addAddress(Map<String, dynamic> body) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    body["user_id"] = userId.toString();
    body["auth_token"] = token;

    /// ✅ DEBUG REQUEST
    print("===== ADDRESS API REQUEST =====");
    print("URL => ${AppUrl.postAddress}");
    print("BODY => $body");

    final response = await dioClient.post(
      AppUrl.postAddress,
      data: body,
    );

    /// ✅ DEBUG RESPONSE
    print("===== ADDRESS API RESPONSE =====");
    print(response);

    if (response["status"] == true) {
      return response["message"] ?? "Address added";
    } else {
      throw Exception(response["message"] ?? "Address add failed");
    }
  }
}