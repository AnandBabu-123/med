import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';
import 'package:medryder/config/routes/app_url.dart';
import '../../bloc/diagnostics_bloc/diagnostics_bloc.dart';
import '../../bloc/diagnostics_bloc/diagnostics_event.dart';
import '../../bloc/diagnostics_bloc/diagnostics_state.dart';
import '../../config/components/app_text_styles/app_text_styles.dart';


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
  State<DiagnosticsScreen> createState()
  => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState
    extends State<DiagnosticsScreen> {

  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    /// FIRST LOAD
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

    /// call API only after 2 letters
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
      appBar: AppBar(title: const Text("Diagnostics",style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor),),
        /// ✅ BACK ARROW COLOR
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      backgroundColor: AppColors.lightblue,),

      body: Column(
        children: [

          /// SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: "Search diagnostics",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// LIST
          Expanded(
            child: BlocBuilder<DiagnosticsBloc, DiagnosticsState>(
              builder: (context, state) {

                if (state.status == DiagnosticsStatus.loading &&
                    state.list.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                if (state.status == DiagnosticsStatus.failure) {
                  return const Center(
                      child: Text("No diagnostics found"));
                }

                if (state.list.isEmpty) {
                  return const Center(
                      child: Text("No diagnostics found"));
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: state.list.length +
                      (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (_, index) {

                    if (index >= state.list.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                            child: CircularProgressIndicator()),
                      );
                    }

                    final item = state.list[index];

                    // return Card(
                    //   margin: const EdgeInsets.symmetric(
                    //       horizontal: 12, vertical: 6),
                    //   child: ListTile(
                    //     leading: ClipRRect(
                    //       borderRadius: BorderRadius.circular(8),
                    //       child: Image.network(
                    //         AppUrl.imageBaseUrl+item.logo,
                    //         width: 55,
                    //         height: 55,
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //
                    //     title: Text(
                    //       item.name,
                    //       style: const TextStyle(
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ),
                    //
                    //     /// ✅ MULTIPLE TEXTS
                    //     subtitle: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //
                    //         /// Location
                    //         Text(
                    //           item.location,
                    //           maxLines: 2,
                    //           overflow: TextOverflow.ellipsis,
                    //           style: TextStyle( fontWeight: FontWeight.w600,
                    //             fontSize: 13
                    //           ),
                    //         ),
                    //
                    //         const SizedBox(height: 4),
                    //
                    //         /// Row text (example)
                    //         Row(
                    //           children: [
                    //             const Icon(Icons.access_time, size: 14, color: Colors.black,fontWeight: FontWeight.w500,),
                    //             const SizedBox(width: 4),
                    //
                    //             Text(
                    //               "Opens/${item.openTime} - Closed/${item.closeTime}",
                    //               style: const TextStyle(
                    //                 fontSize: 12,
                    //                 fontWeight: FontWeight.w500,
                    //                 color: Colors.black,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // );

                    return Card(
                      elevation: 0,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: ClipOval(
                          child: Image.network(
                            "https://medconnect.org.in/bharosa/${item.logo}",
                            width: 65,
                            height: 65,
                            fit: BoxFit.cover,
                          ),
                        ),

                        title: Text(
                          item.name,
                          style: AppTextStyles.title,
                        ),

                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            const SizedBox(height: 4),

                            /// Opens text
                            Text(
                              "Opens ${item.openTime} / Closed ${item.closeTime}",
                              style: AppTextStyles.timing,
                            ),

                            const SizedBox(height: 6),

                            /// Location row
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 16, color: Colors.black54),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    item.location,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles.location,
                                  ),
                                ),
                              ],
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
