class AppUrls {
  static const String baseUrl = 'http://3.111.125.81';

  static const String loginApi = '$baseUrl/user/login';

  static String storeDetailsApi(String userId) =>
      '$baseUrl/store/storeDetails?userId=$userId';
}
