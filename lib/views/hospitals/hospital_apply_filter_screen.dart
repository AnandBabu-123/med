import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/hospital_apply_filter_bloc/hospital_apply_filter_bloc.dart';
import '../../bloc/hospital_apply_filter_bloc/hospital_apply_filter_event.dart';
import '../../bloc/hospital_apply_filter_bloc/hospital_apply_filter_state.dart';
import '../../config/colors/app_colors.dart';


class HospitalApplyFilterScreen extends StatefulWidget {

  final String lat;
  final String lon;
  final String language;
  final int subCatId;
  final String subSubCatIds;

  const HospitalApplyFilterScreen({
    super.key,
    required this.lat,
    required this.lon,
    required this.language,
    required this.subCatId,
    required this.subSubCatIds,
  });

  @override
  State<HospitalApplyFilterScreen> createState() =>
      _HospitalApplyFilterScreenState();
}

class _HospitalApplyFilterScreenState extends State<HospitalApplyFilterScreen> {

  @override
  void initState() {
    super.initState();

    context.read<HospitalApplyFilterBloc>().add(
      ApplyHospitalFilterEvent(
        language: widget.language,
        lat: widget.lat,
        lon: widget.lon,
        subCatId: widget.subCatId,
        subSubCatIds: widget.subSubCatIds,
        page: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar:AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Filtered Hospitals",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<HospitalApplyFilterBloc, HospitalApplyFilterState>(
        builder: (context, state) {

          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.hospitals.isEmpty) {
            return const Center(
              child: Text(
                "No hospitals found",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            itemCount: state.hospitals.length,
            itemBuilder: (context, index) {

              final hospital = state.hospitals[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(

                  /// HOSPITAL IMAGE
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      hospital.logo, // your API image field
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(
                            Icons.local_hospital,
                            color: Colors.red,
                            size: 50,
                          ),
                        );
                      },
                    ),
                  ),

                  title: Text(
                    hospital.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      const SizedBox(height: 4),

                      /// LOCATION
                      Text(
                        hospital.location,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),

                      const SizedBox(height: 6),

                      /// OPEN & CLOSE TIME
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 4),

                          Text(
                            "Open: ${hospital.openTime}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),

                          const SizedBox(width: 4),

                          Text(
                            "Close: ${hospital.closeTime}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
