import 'dart:convert';
import 'package:dio/dio.dart';

import '../../models/banner_model.dart';


class BannerRepository {

  final Dio dio = Dio();

  static const String API_URL =
      "https://medrayder.in/bharosa/app/ws/banners";

  Future<List<BannerModel>> fetchBanners() async {

    final response = await dio.get(API_URL);

    final data = response.data is String
        ? jsonDecode(response.data)
        : response.data;

    final List banners = data['response']['banners'];

    print("TOTAL BANNERS => ${banners.length}");

    return banners
        .map((e) => BannerModel.fromJson(e))
        .toList();
  }
}


// class BannerRepository {
//
//   final DioClient dioClient;
//
//   BannerRepository(this.dioClient);
//
//   Future<List<BannerModel>> fetchBanners() async {
//
//     final response = await dioClient.get(AppUrl.banners);
//
//     /// Handle String or Map response
//     final data = response is String
//         ? jsonDecode(response)
//         : response;
//
//     /// Safe parsing (prevents null crash)
//     final List banners =
//         data['response']?['banners'] ?? [];
//
//     print("TOTAL BANNERS => ${banners.length}");
//
//     return banners
//         .map((e) => BannerModel.fromJson(e))
//         .toList();
//   }
// }

