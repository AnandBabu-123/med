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


  /// 🔹 SAVE LOGIN DATA
  Future<void> saveUser(LoginModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userIdKey, user.userId ?? '');
    await prefs.setString(_usernameKey, user.username ?? '');
    await prefs.setString(_userTypeKey, user.userType ?? '');
    await prefs.setString(_emailKey, user.userEmailAddress ?? '');
    await prefs.setString(_contactKey, user.userContact ?? '');
    await prefs.setString(_tokenKey, user.token ?? '');
    await prefs.setString(_roleKey, user.dashboardRole ?? '');
  }

  /// 🔹 GETTERS
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getUsername() async =>
      (await SharedPreferences.getInstance()).getString(_usernameKey);

  Future<String?> getToken() async =>
      (await SharedPreferences.getInstance()).getString(_tokenKey);

  /// 🔹 CLEAR (Logout)
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
