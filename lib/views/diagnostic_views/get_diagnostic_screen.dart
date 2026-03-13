import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';
import '../../bloc/diagnostics_bloc/diagnostics_bloc.dart';
import '../../bloc/diagnostics_bloc/diagnostics_event.dart';
import '../../bloc/diagnostics_bloc/diagnostics_state.dart';
import '../../config/routes/app_url.dart';
import '../../config/routes/routes_name.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/diagnostic_tests_repository/diagnostic_tests_repository.dart';


class DiagnosticsScreen extends StatefulWidget {
  final String lat;
  final String lon;
  final String language;

  const DiagnosticsScreen({
    super.key,
    required this.lat,
    required this.lon,
    required this.language,
  });

  @override
  State<DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<DiagnosticsScreen> {

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// FIRST API CALL
    context.read<DiagnosticsBloc>().add(
      FetchDiagnostics(
        lat: widget.lat,
        lon: widget.lon,
        language: widget.language,
        page: 1,
        search: "",
      ),
    );

    scrollController.addListener(_onScroll);
  }

  /// ================= PAGINATION =================
  void _onScroll() {
    if (!scrollController.hasClients) return;

    final bloc = context.read<DiagnosticsBloc>();

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {

      if (!bloc.state.hasReachedMax &&
          bloc.state.status != DiagnosticsStatus.loading) {

        bloc.add(
          FetchDiagnostics(
            lat: widget.lat,
            lon: widget.lon,
            language: widget.language,
            page: bloc.state.page + 1,
            search: bloc.state.search,
          ),
        );
      }
    }
  }

  /// ================= SEARCH =================
  void _onSearch(String value) {
    if (value.length >= 2 || value.isEmpty) {
      context.read<DiagnosticsBloc>().add(
        FetchDiagnostics(
          lat: widget.lat,
          lon: widget.lon,
          language: widget.language,
          page: 1,
          search: value,
        ),
      );
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      /// ================= APPBAR =================
      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Diagnostics",
            style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor)
        ),
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: "Search diagnostics",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),



          /// ================= LIST =================
          Expanded(
            child: BlocBuilder<DiagnosticsBloc, DiagnosticsState>(
              builder: (context, state) {

                if (state.status == DiagnosticsStatus.loading &&
                    state.list.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.list.isEmpty) {
                  return const Center(
                    child: Text(
                      "No diagnostics found",
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                  );
                }

                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.only(bottom: 12),
                  itemCount: state.list.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (_, index) {

                    /// Pagination loader
                    if (index >= state.list.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final item = state.list[index];

                    return GestureDetector(

                        onTap: () async {

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(child: CircularProgressIndicator()),
                          );

                          try {

                            final repository = DiagnosticTestsRepository(
                              DioClient(
                                dio: Dio(),
                                networkInfo: NetworkInfo(),
                              ),
                            );

                            final tests = await repository.getDiagnosticTests(
                              diagnosticId: item.id,
                              page: 1,
                              language: widget.language,
                            );

                            Navigator.pop(context);

                            /// TESTS AVAILABLE
                            if (tests.isNotEmpty) {

                              Navigator.pushNamed(
                                context,
                                RoutesName.test_diagnostic,
                                arguments: {
                                  "diagnostic_id": item.id,
                                  "language": widget.language,
                                },
                              );

                            } else {

                              /// EMPTY LIST
                              Navigator.pushNamed(
                                context,
                                RoutesName.attachPrescriptionScreen,
                                arguments: {
                                  "diagnostic_id": item.id,
                                  "language": widget.language,
                                  "location": item.location,
                                  "lab_name": item.name,
                                  "open_time": item.openTime,
                                  "close_time": item.closeTime,
                                },
                              );

                            }

                          } catch (e) {

                            /// CLOSE LOADER
                            Navigator.pop(context);

                            /// API RETURNED NO TESTS → GO TO PRESCRIPTION
                            Navigator.pushNamed(
                              context,
                              RoutesName.attachPrescriptionScreen,
                              arguments: {
                                "diagnostic_id": item.id,
                                "language": widget.language,
                                "location": item.location,
                                "lab_name": item.name,
                                "open_time": item.openTime,
                                "close_time": item.closeTime,
                              },
                            );

                          }
                        },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// LAB LOGO
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (item.logo.isEmpty || item.logo == "null")
                                  ? Image.asset(
                                "assets/logo.png",
                                width: 70,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                "${AppUrl.imageBaseUrl}/${item.logo}",
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

                            const SizedBox(width: 12),

                            /// DETAILS
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// NAME
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: AppColors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// TIMINGS
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 16,
                                          color: Colors.black54),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Open ${item.openTime} • Close ${item.closeTime}",
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 6),

                                  /// LOCATION
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16,
                                          color: Colors.redAccent),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          item.location,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
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
