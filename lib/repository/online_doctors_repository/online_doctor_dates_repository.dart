import '../../config/routes/app_url.dart';
import '../../models/online_doctors_model/online_booking_response.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class OnlineDoctorDatesRepository {

  final DioClient dioClient;

  OnlineDoctorDatesRepository(this.dioClient);

  Future<OnlineDoctorBookingResponse> onlineDoctorsDates({
    required String language,
    required int specialityId,
    required String viewType,
    String? date,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "language": language,
      "speciality_id": specialityId,
      "view_type": viewType,
      "date": date
    };

    final response = await dioClient.post(
      AppUrl.onlineDoctorDates,
      data: body,
    );

    return OnlineDoctorBookingResponse.fromJson(response);
  }
}