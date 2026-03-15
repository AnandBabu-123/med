
import '../../config/routes/app_url.dart';
import '../../models/lab_test_models/lab_booking_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class LabTestBookingRepository {

  final DioClient dioClient;

  LabTestBookingRepository(this.dioClient);

  Future<LabBookingModel> labBookingRepository({

    required int labTestId,
    required int testId,
    required int fee,
    required String viewType,
    required String date,
    required int familyMemberId,
    required int count,

  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "view_type": viewType,
      "lab_test_id": labTestId,
      "test_id": testId,
      "date": date,
      "fee": fee,
      "family_member_id": familyMemberId,
      "count": count,
      "image": "",
      "language": "en"
    };

    final response = await dioClient.post(
      AppUrl.labTestBooking,
      data: body,
    );

    print("===== LAB BOOKING RESPONSE =====");
    print(response);

    return LabBookingModel.fromJson(response);
  }
}