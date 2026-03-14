
import 'package:medryder/models/online_doctors_model/online_doctor_coupon_model.dart';

import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class OnlineDoctorCouponRepository {

  final DioClient dioClient;

  OnlineDoctorCouponRepository(this.dioClient);

  Future<OnlineDoctorCouponResponse> onlineDoctorCoupon({
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
    };

    final response = await dioClient.post(
      AppUrl.onlineDoctorCoupon,
      data: body,
    );

    return OnlineDoctorCouponResponse.fromJson(response);
  }
}