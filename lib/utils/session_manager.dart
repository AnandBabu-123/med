import 'package:shared_preferences/shared_preferences.dart';

import '../models/login/login_model.dart';

class SessionManager {
  static const String _userIdKey = "userId";
  static const String _usernameKey = "username";
  static const String _userTypeKey = "userType";
  static const String _emailKey = "userEmail";
  static const String _contactKey = "userContact";
  static const String _tokenKey = "token";
  static const String _roleKey = "dashboardRole";

  static const String userIdKey = "user_id";
  static const String mobileKey = "mobile";
  static const String emailKey = "email";
  static const String tokenKey = "auth_token";

  static Future<void> saveUser({
    required int id,
    required int mobile,
    required String email,
    required String token,
  }) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("user_id", id);
    await prefs.setInt("mobile", mobile);
    await prefs.setString("email", email);
    await prefs.setString("auth_token", token);
  }
  /// ✅ GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// ✅ LOGOUT CLEAR
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }




  /// 🔹 GETTERS
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUsername() async =>
      (await SharedPreferences.getInstance()).getString(_usernameKey);


}
