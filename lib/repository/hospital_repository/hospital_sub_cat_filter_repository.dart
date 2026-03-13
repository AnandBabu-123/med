import '../../config/routes/app_url.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';

class HospitalSubCatFilterRepository {

  final DioClient dioClient;

  HospitalSubCatFilterRepository(this.dioClient);

  Future<dynamic> hospitalSubCatFilterData({
    required String language,
    required String lat,
    required String lon,
    required int subCatId,

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
    print("page: $page");

    /// CREATE REQUEST BODY
    final body = {
      "user_id": userId,
      "auth_token": token,
      "sub_cat_id": subCatId.toString(),
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
      AppUrl.hospitalSubCatFilter,
      data: body,
    );

    /// PRINT RESPONSE
    /// PRINT RESPONSE
    print("===== HOSPITAL APPLY FILTER RESPONSE =====");
    print(response);

    return response;
  }
}