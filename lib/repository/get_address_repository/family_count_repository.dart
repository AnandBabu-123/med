import '../../config/routes/app_url.dart';
import '../../models/family_member_model/family_member_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class FamilyCountRepository {
  final DioClient dioClient;

  FamilyCountRepository(this.dioClient);

  Future<FamilyCountModel> getFamilyCount() async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId.toString(),
      "auth_token": token,
    };

    print("===== FAMILY COUNT REQUEST =====");
    print(body);

    final response = await dioClient.post(
      AppUrl.familyMembers,
      data: body,
    );

    print("===== FAMILY COUNT RESPONSE =====");
    print(response);

    if (response["status"] == true) {

      return FamilyCountModel.fromJson(response);

    } else {
      throw Exception(response["message"]);
    }
  }
}