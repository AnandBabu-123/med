import 'package:shared_preferences/shared_preferences.dart';


class SessionManager {

  static const String userIdKey = "user_id";
  static const String mobileKey = "mobile";
  static const String emailKey = "email";
  static const String tokenKey = "auth_token";

  static const _languageKey = "selected_language";

  static const _addressKey = "user_address";
  static const _latKey = "user_lat";
  static const _lonKey = "user_lon";


  static const String _addressIdKey = "id";

  static Future<void> saveAddress(
      String address,
      String lat,
      String lon,
      int addressId,
      ) async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_addressKey, address);
    await prefs.setString(_latKey, lat);
    await prefs.setString(_lonKey, lon);
    await prefs.setInt(_addressIdKey, addressId);

    print("Saved Address ID: $addressId");
    print("Saved Address: $address");
    print("Saved Lat: $lat");
    print("Saved Lon: $lon");
  }

  /// GET ADDRESS
  static Future<String?> getAddress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_addressKey);
  }

  static Future<String?> getLat() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_latKey);
  }

  static Future<String?> getLon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lonKey);
  }

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

  ///  GET USER ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(userIdKey);
  }

  static Future<int?> getUserMobile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(mobileKey);
  }

  ///  GET TOKEN
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
