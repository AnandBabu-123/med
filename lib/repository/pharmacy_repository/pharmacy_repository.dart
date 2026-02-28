import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/app_urls.dart';
import '../../models/pharmacy_model/pharmacy_category_model.dart';
import '../../utils/session_manager.dart';

class PharmacyRepository {

  static const String imageBaseUrl =
      "https://medconnect.org.in/bharosa/";

  Future<List<PharmacyCategoryModel>> fetchCategories(
      String language) async
  {

    final userId = await SessionManager.getUserId();
    final token = await SessionManager.getToken();

    final response = await http.post(
      Uri.parse(AppUrls.pharmacy_categories),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "user_id": userId.toString(),
        "auth_token": token,
        "language": language,
      }),
    );

    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["status"] == true) {

      final List list =
      data["response"]["pharmacy_categories"];

      return list
          .map((e) => PharmacyCategoryModel.fromJson(e))
          .toList();
    } else {
      throw Exception(data["message"]);
    }
  }
}