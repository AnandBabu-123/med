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

