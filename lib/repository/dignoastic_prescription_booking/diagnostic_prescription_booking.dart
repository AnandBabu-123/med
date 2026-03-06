import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class DiagnosticPrescriptionRepository {

  final DioClient dioClient;

  DiagnosticPrescriptionRepository(this.dioClient);

  Future uploadPrescription({

    required int diagnosticId,
    required String image,
    required String name,
    required String mobile,
    required int familyMemberId,
    required String language,

  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {

      "user_id": userId,
      "auth_token": token,
      "diagnostic_id": diagnosticId,
      "view_type": "order",
      "image": image,
      "name": name,
      "mobile": mobile,
      "family_member_id": familyMemberId,
      "language": language

    };

    final response = await dioClient.post(
      AppUrl.diagnosticPrescriptionBooking,
      data: body,
    );

    if (response["status"] == true) {

      return response;

    } else {

      throw Exception(response["message"]);

    }
  }
}