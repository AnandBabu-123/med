import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';
import 'package:medryder/views/pharmacy/pharmacy_details_screen.dart';

import '../../bloc/pharmacy_bloc/pharmacy_bloc.dart';
import '../../bloc/pharmacy_bloc/pharmacy_event.dart';
import '../../bloc/pharmacy_bloc/pharmacy_state.dart';
import '../../bloc/pharmacy_details_bloc/pharmacy_details_bloc.dart';
import '../../config/routes/app_url.dart';
import '../../config/routes/routes_name.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/pharmacy_repository/pharmacy_details_repository.dart';

class PharmacyScreen extends StatefulWidget {

  final String lat;
  final String lon;
  final String language;

  const PharmacyScreen({
    super.key,
    required this.lat,
    required this.lon,
    required this.language,
  });

  @override
  State<PharmacyScreen> createState() => _PharmacyScreenState();
}

class _PharmacyScreenState extends State<PharmacyScreen> {
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  static const String imageBaseUrl =
      "https://medrayder.in/bharosa/";

  @override
  void initState() {
    super.initState();
    _loadPharmacies();

    _scrollController.addListener(_onScroll);
    context.read<PharmacyBloc>().add(
      FetchPharmacyCategories(
        lat: widget.lat,
        lon: widget.lon,
        language: widget.language,
      ),
    );
  }

  void _loadPharmacies({String search = ""}) {

    context.read<PharmacyBloc>().add(
      FetchPharmacyCategories(
        lat: widget.lat,
        lon: widget.lon,
        language: widget.language,
        page: 1,
        search: search,
      ),
    );
  }

  void _onScroll() {

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {

      final bloc = context.read<PharmacyBloc>();

      if (!bloc.state.hasReachedMax) {

        bloc.add(
          FetchPharmacyCategories(
            lat: widget.lat,
            lon: widget.lon,
            language: widget.language,
            page: bloc.state.page + 1,
            search: searchController.text,
            isLoadMore: true,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [

          /// HEADER
          Container(
            color: AppColors.lightblue,
            padding: const EdgeInsets.only(
              top: 40,
              left: 12,
              right: 12,
              bottom: 16,
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 30,),
                    const Expanded(
                      child: Text(
                          "Pharmacy",
                          style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 22)
                      ),
                    ),
                    const SizedBox(width: 48)
                  ],
                ),

                const SizedBox(height: 10),

                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                  TextField(
                    controller: searchController,
                    onChanged: (value) {

                      context.read<PharmacyBloc>().add(
                        FetchPharmacyCategories(
                          lat: widget.lat,
                          lon: widget.lon,
                          language: widget.language,
                          page: 1,
                          search: value,
                        ),
                      );
                    },
                    decoration: const InputDecoration(
                      hintText: "Search medicines...",
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  )
                ),
              ],
            ),
          ),

          /// API LIST
          Expanded(
            child:
            BlocBuilder<PharmacyBloc, PharmacyState>(
              builder: (context, state) {

                if (state.status == PharmacyStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == PharmacyStatus.failure) {
                  return Center(child: Text(state.message));
                }

                if (state.categories.isEmpty) {
                  return const Center(
                    child: Text("No Pharmacy Categories Found"),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: state.categories.length + 1,
                  itemBuilder: (context, index) {

                    /// 🔹 Pagination loader
                    if (index >= state.categories.length) {

                      if (state.hasReachedMax) {
                        return const SizedBox();
                      }

                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    /// 🔹 Safe item access
                    final item = state.categories[index];

                    final imageUrl = imageBaseUrl + item.logo;

                    final bool isHomeDelivery =
                        item.homeDelivery.toLowerCase() == "yes";

                    return GestureDetector(
                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => PharmacyDetailsBloc(
                                PharmacyDetailsRepository(
                                  DioClient(
                                    dio: Dio(),
                                    networkInfo: NetworkInfo(),
                                  ),
                                ),
                              ),
                              child: PharmacyDetailsScreen(
                                pharmacyId: item.id,
                                language: widget.language,
                                location: item.location,
                              ),
                            ),
                          ),
                        );

                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: Row(
                          children: [

                            /// Pharmacy Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (item.name.isEmpty || item.name == "null")
                                  ? Image.asset(
                                "assets/logo.png",
                                width: 70,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                "${AppUrl.imageBaseUrl}/${item.name}",
                                width: 70,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/logo.png",
                                    width: 70,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(width: 14),

                            /// Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 16, color: Colors.grey),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${item.openTime} - ${item.closeTime}",
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.red),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          item.location,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isHomeDelivery
                                          ? Colors.green.shade50
                                          : Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      isHomeDelivery
                                          ? "Home Delivery"
                                          : "Pickup Order",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: isHomeDelivery
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
