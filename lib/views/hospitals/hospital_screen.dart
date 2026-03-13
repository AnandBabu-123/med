import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/hospital_bloc/hospital_bloc.dart';
import '../../bloc/hospital_bloc/hospital_event.dart';
import '../../bloc/hospital_bloc/hospital_state.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/app_url.dart';
import '../../config/routes/routes_name.dart';

class HospitalScreen extends StatefulWidget {

  final String lat;
  final String lon;
  final String language;

  const HospitalScreen({
    super.key,
    required this.lat,
    required this.lon,
    required this.language,
  });

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();

    context.read<HospitalBloc>().add(
      FetchHospitalsEvent(
        lat: widget.lat,
        lon: widget.lon,
        language: widget.language,
      ),
    );

    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {

      final bloc = context.read<HospitalBloc>();
      final state = bloc.state;

      bloc.add(
        FetchHospitalsEvent(
          lat: widget.lat,
          lon: widget.lon,
          language: widget.language,
          page: state.page,
          search: searchController.text,
          isPagination: true,
        ),
      );
    }
  }

  void _searchHospital(String value) {

    context.read<HospitalBloc>().add(
      FetchHospitalsEvent(
        lat: widget.lat,
        lon: widget.lon,
        language: widget.language,
        search: value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
          backgroundColor: AppColors.lightblue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Hospitals",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
              fontSize: 20,
            ),
          ),
      ),

      body: Column(
        children: [

          /// Search Field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                isDense: true,
                hintText: "Search Hospitals",
                border: OutlineInputBorder(),
              ),
              onChanged: _searchHospital,
            ),
          ),

          /// Top Hospitals + Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// Title
                const Text(
                  "Showing Top Hospitals Near You",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                /// Filter Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      RoutesName.hospitalFilterScreen,
                      arguments: {
                        "language": widget.language,
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.filter_list,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// Hospital List
          Expanded(
            child: BlocBuilder<HospitalBloc, HospitalState>(
              builder: (context, state) {

                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error.isNotEmpty) {
                  return Center(child: Text(state.error));
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: state.paginationLoading
                      ? state.hospitals.length + 1
                      : state.hospitals.length,
                  itemBuilder: (context, index) {

                    if (index >= state.hospitals.length) {
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final hospital = state.hospitals[index];

                    // Your hospital container card here
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          /// Logo
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: (hospital.logo.isEmpty || hospital.logo == "null")
                                ? Image.asset(
                              "assets/logo.png",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              "${AppUrl.imageBaseUrl}/${hospital.logo}",
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  "assets/logo.png",
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  hospital.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  hospital.tagline,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[700],
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        size: 16, color: Colors.redAccent),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        hospital.location,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 6),

                                Row(
                                  children: [
                                    const Icon(Icons.access_time,
                                        size: 16, color: Colors.green),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${hospital.openTime} - ${hospital.closeTime}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
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
