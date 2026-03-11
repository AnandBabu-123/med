

import 'package:medryder/models/hospital_model/hospital_apply_filter_model.dart';

import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class HospitalApplyFilterRepository {

  final DioClient dioClient;

  HospitalApplyFilterRepository(this.dioClient);

  Future<ApplyFilterModel> hospitalApplyFilterData({
    required String language,
    required String lat,
    required String lon,
    required int subCatId,
    required String subSubCatIds,
    required int page,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    /// PRINT INPUT PARAMETERS
    print("===== APPLY FILTER PARAMETERS =====");
    print("language: $language");
    print("lat: $lat");
    print("lon: $lon");
    print("subCatId: $subCatId");
    print("subSubCatIds: $subSubCatIds");
    print("page: $page");

    /// CREATE REQUEST BODY
    final body = {
      "user_id": userId,
      "auth_token": token,
      "cat_id": 1,
      "sub_cat_id": subCatId.toString(),
      "sub_sub_cat_id": subSubCatIds,
      "lat": lat,
      "lon": lon,
      "page": page,
      "language": language,
    };

    /// PRINT SESSION DATA
    print("===== SESSION DATA =====");
    print("user_id: $userId");
    print("token: $token");

    /// PRINT FINAL REQUEST BODY
    print("===== FINAL REQUEST BODY =====");
    print(body);

    /// API CALL
    final response = await dioClient.post(
      AppUrl.hospitalApplyFilter,
      data: body,
    );

    /// PRINT RESPONSE
    print("===== HOSPITAL APPLY FILTER RESPONSE =====");
    print(response);

    return ApplyFilterModel.fromJson(response);
  }
}