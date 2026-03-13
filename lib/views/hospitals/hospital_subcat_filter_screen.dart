import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/hospital_sub_cat_filter_bloc/hospital_sub_cat_filter_bloc.dart';
import '../../bloc/hospital_sub_cat_filter_bloc/hospital_sub_cat_filter_state.dart';

class HospitalSubCatFilterScreen extends StatelessWidget {

  final String lat;
  final String lon;
  final String language;
  final int subCatId;

  const HospitalSubCatFilterScreen({
    super.key,
    required this.lat,
    required this.lon,
    required this.language,
    required this.subCatId,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hospital Details"),
      ),

      body: BlocBuilder<HospitalSubCatFilterBloc, HospitalSubCatFilterState>(
        builder: (context, state) {

          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: state.hospitals.length,
            itemBuilder: (context, index) {

              final hospital = state.hospitals[index];

              return ListTile(
                title: Text(hospital["name"] ?? ""),
                subtitle: Text(hospital["location"] ?? ""),
              );
            },
          );
        },
      ),
    );
  }
}
