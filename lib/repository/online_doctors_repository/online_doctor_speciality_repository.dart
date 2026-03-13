import 'package:medryder/models/online_doctors_model/online_doctor_speciality_model.dart';
import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class OnlineDoctorSpecialityRepository {

  final DioClient dioClient;

  OnlineDoctorSpecialityRepository(this.dioClient);

  Future<OnlineDoctorSpecialityModel> onlineDoctorsSpeciality({
    required String language,
    required int specialityId,
    required int page,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "language": language,
      "speciality_id": specialityId,
      "page": page,
    };

    final response = await dioClient.post(
      AppUrl.onlineDoctorsSpeciality,
      data: body,
    );
print("${response}");
    /// response already Map
    return OnlineDoctorSpecialityModel.fromJson(response);
  }
}