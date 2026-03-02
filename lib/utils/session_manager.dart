import 'package:shared_preferences/shared_preferences.dart';


class SessionManager {

  static const String userIdKey = "user_id";
  static const String mobileKey = "mobile";
  static const String emailKey = "email";
  static const String tokenKey = "auth_token";

  static const _languageKey = "selected_language";

  static Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
  }

  static Future<String> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_languageKey) ?? "en";
  }

  /// SAVE
  static Future<void> saveUser({
    required int id,
    required int mobile,
    required String email,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(userIdKey, id);
    await prefs.setInt(mobileKey, mobile);
    await prefs.setString(emailKey, email);
    await prefs.setString(tokenKey, token);
  }

  /// ✅ GET USER ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  /// ✅ GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  /// DEBUG
  static Future<void> printSession() async {
    final prefs = await SharedPreferences.getInstance();

    print("USER_ID => ${prefs.getInt(userIdKey)}");
    print("TOKEN => ${prefs.getString(tokenKey)}");
  }
}
