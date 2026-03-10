import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/routes/app_url.dart';
import '../../models/pharmacy_model/pharmacy_category_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../utils/session_manager.dart';



class PharmacyRepository {

  final DioClient dioClient;

  PharmacyRepository(this.dioClient);

  Future<PharmacyResponseModel> getPharmacies({
    required String lat,
    required String lon,
    required String language,
    required int page,
    required String search,
  }) async {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final body = {
      "user_id": userId,
      "auth_token": token,
      "lat": lat,
      "lon": lon,
      "page": page,
      "search": search,
      "language": language,
    };

    final response = await dioClient.post(
      AppUrl.pharmacyCategories,
      data: body,
    );

    print("PHARMACY RESPONSE => $response");

    return PharmacyResponseModel.fromJson(response);
  }
}