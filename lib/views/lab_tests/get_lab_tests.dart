import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';
import '../../bloc/lab_test_bloc/lab_test_bloc.dart';
import '../../bloc/lab_test_bloc/lab_test_event.dart';
import '../../bloc/lab_test_bloc/lab_test_state.dart';
import '../../config/routes/app_url.dart';

class GetLabTests extends StatefulWidget {
  final String lat;
  final String lon;
  final String language;

  const GetLabTests({
    super.key,
    required this.lat,
    required this.lon,
    required this.language,
  });

  @override
  State<GetLabTests> createState() => _GetLabTestsState();
}

class _GetLabTestsState extends State<GetLabTests> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// FIRST API CALL
    context.read<LabTestBloc>().add(
      FetchLabTest(
        lat: widget.lat,
        lon: widget.lon,
        language: widget.language,
        page: 1,
      ),
    );

    /// PAGINATION LISTENER
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final bloc = context.read<LabTestBloc>();

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {

      if (!bloc.state.hasReachedMax &&
          bloc.state.status != LabTestStatus.loading) {

        bloc.add(
          FetchLabTest(
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

  /// SEARCH
  void _onSearch(String value) {
    context.read<LabTestBloc>().add(
      FetchLabTest(
        lat: widget.lat,
        lon: widget.lon,
        language: widget.language,
        page: 1,
        search: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      /// ================= APPBAR =================
      appBar: AppBar(
        title: const Text("Lab Tests",style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor),),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor:AppColors.lightblue,
      ),

      body: Column(
        children: [

          /// ================= SEARCH =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: "Search labs...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          /// ================= LIST =================
          Expanded(
            child: BlocBuilder<LabTestBloc, LabTestState>(
              builder: (context, state) {

                if (state.status == LabTestStatus.loading &&
                    state.list.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.status == LabTestStatus.failure) {
                  return const Center(
                    child: Text("Failed to load labs"),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.hasReachedMax
                      ? state.list.length
                      : state.list.length + 1,

                  itemBuilder: (context, index) {

                    /// PAGINATION LOADER
                    if (index >= state.list.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final lab = state.list[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 6,
                          )
                        ],
                      ),

                      child: Row(
                        children: [

                          /// ✅ CIRCULAR IMAGE
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue.shade50,
                            backgroundImage: NetworkImage(
                              "${AppUrl.imageBaseUrl}/${lab.logo}",
                            ),
                          ),

                          const SizedBox(width: 14),

                          /// NAME + LOCATION
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  lab.name,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  lab.location,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  "Opens ${lab.openTime}/Close ${lab.closeTime}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
