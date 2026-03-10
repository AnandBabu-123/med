import '../../config/routes/app_url.dart';
import '../../models/family_member_model/total_family_members_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class GetFamilyMembersRepository {

  final DioClient dioClient;

  GetFamilyMembersRepository(this.dioClient);

  Future<List<FamilyMember>> getFamilyMembers() async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId.toString(),
      "auth_token": token,
    };

    print(body);

    final response = await dioClient.post(
      AppUrl.totalFamilyMembers,
      data: body,
    );

    print("===== FAMILY MEMBERS RESPONSE =====");
    print(response);

    if (response["status"] == true) {

      final model = TotalFamilyMembersModel.fromJson(response);

      return model.familyMembers;

    } else {

      throw Exception(response["message"]);
    }
  }
}