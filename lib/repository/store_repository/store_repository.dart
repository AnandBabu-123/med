
import '../../config/app_urls.dart';
import '../../models/storeModel/store_model.dart';
import '../../network/network_api_service.dart';
import '../../utils/session_manager.dart';

class StoreRepository {
  final _api = NetworkApiService();
  final _session = SessionManager();

  Future<List<StoreModel>> fetchStores() async {
    final userId = await _session.getUserId();

    if (userId == null) throw Exception("User not logged in");

    final response = await _api.getApi(
      AppUrls.storeDetailsApi(userId),
      isAuthRequired: true,
    );

    final List storeList = response.data["stores"];

    return storeList.map((e) => StoreModel.fromJson(e)).toList();
  }
}


