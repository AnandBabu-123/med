import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/hospital_filter_bloc/hospital_filter_bloc.dart';
import '../../bloc/hospital_filter_bloc/hospital_filter_event.dart';
import '../../bloc/hospital_filter_bloc/hospital_filter_state.dart';
import '../../config/colors/app_colors.dart';

class HospitalFilterScreen extends StatelessWidget {

  final String language;

  const HospitalFilterScreen({super.key, required this.language});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      bottom: true,
      child: Scaffold(

        appBar: AppBar(
          backgroundColor: AppColors.lightblue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Filter Hospitals",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
              fontSize: 20,
            ),
          ),
        ),

        body: BlocBuilder<HospitalFilterBloc, HospitalFilterState>(
          builder: (context, state) {

            if (state.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.categories.isEmpty) {
              return const Center(child: Text("No Data"));
            }

            final categories = state.categories;
            final selectedIndex = state.selectedCategoryIndex;
            final specialities = categories[selectedIndex].specialities;

            return Column(
              children: [

                /// FILTER AREA
                Expanded(
                  child: Row(
                    children: [

                      /// LEFT CATEGORY LIST
                      Container(
                        width: 160,
                        color: Colors.grey.shade100,
                        child: ListView.separated(

                          itemCount: categories.length,

                          separatorBuilder: (_, __) =>
                          const Divider(height: 1),

                          itemBuilder: (context, index) {

                            final selected = index == selectedIndex;

                            return InkWell(

                              onTap: () {
                                context.read<HospitalFilterBloc>().add(
                                  ChangeCategory(index),
                                );
                              },

                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                color: selected
                                    ? Colors.white
                                    : Colors.grey.shade100,
                                child: Text(
                                  categories[index].categoryName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: selected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      /// RIGHT SPECIALITY LIST
                      Expanded(
                        child: ListView.separated(

                          itemCount: specialities.length,

                          separatorBuilder: (_, __) =>
                          const Divider(height: 1),

                          itemBuilder: (context, index) {

                            final speciality = specialities[index];

                            final selected = state.selectedSpecialities
                                .contains(speciality.specialityId);

                            return InkWell(

                              onTap: () {
                                context.read<HospitalFilterBloc>().add(
                                  ToggleSpeciality(
                                      speciality.specialityId),
                                );
                              },

                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 6),

                                child: Row(

                                  children: [

                                    Checkbox(
                                      value: selected,
                                      onChanged: (_) {
                                        context
                                            .read<HospitalFilterBloc>()
                                            .add(
                                          ToggleSpeciality(
                                              speciality.specialityId),
                                        );
                                      },
                                    ),



                                    Expanded(
                                      child: Text(
                                        speciality.specialityName,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                /// BOTTOM BUTTONS
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey),
                    ),
                  ),

                  child: Row(

                    children: [

                      /// RESET BUTTON
                      Expanded(
                        child: OutlinedButton(

                          onPressed: () {

                            context.read<HospitalFilterBloc>().add(
                              ResetFilters(),
                            );
                          },

                          child: const Text(
                            "Reset",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// APPLY BUTTON
                      Expanded(
                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),

                          onPressed: () {

                            final selected = context
                                .read<HospitalFilterBloc>()
                                .state
                                .selectedSpecialities;

                            Navigator.pop(context, selected);
                          },

                          child: const Text(
                            "Apply Filter",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
