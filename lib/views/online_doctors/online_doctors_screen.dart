import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/online_doctor_speciality_bloc/online_doctor_speciality_bloc.dart';
import 'package:medryder/bloc/online_doctor_speciality_bloc/online_doctor_speciality_state.dart';
import '../../bloc/online_doctor_speciality_bloc/online_doctor_speciality_event.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/app_url.dart';
import 'doctor_details_screen.dart';

class OnlineDoctorsScreen extends StatefulWidget {

  final String language;

  const OnlineDoctorsScreen({super.key, required this.language});

  @override
  State<OnlineDoctorsScreen> createState() => _OnlineDoctorsScreenState();
}

class _OnlineDoctorsScreenState extends State<OnlineDoctorsScreen> {

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<OnlineDoctorSpecialityBloc>()
        .add(FetchOnlineDoctorsEvent(language: widget.language));

    _scrollController.addListener(_pagination);
  }

  void _pagination() {

    final bloc = context.read<OnlineDoctorSpecialityBloc>();
    final state = bloc.state;

    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {

      if (state.hasMorePages && !state.isPaginationLoading) {

        bloc.add(FetchDoctorsBySpecialityEvent(
          specialityId: state.selectedSpecialityId!,
          language: widget.language,
          isPagination: true,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Online Doctors",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: BlocBuilder<OnlineDoctorSpecialityBloc, OnlineDoctorSpecialityState>(
        builder: (context, state) {

          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [

              /// DROPDOWN
              Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<int>(

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  value: state.selectedSpecialityId,

                  items: state.specialities.map((e) {

                    return DropdownMenuItem(
                      value: e.id,
                      child: Text(e.name),
                    );

                  }).toList(),

                  onChanged: (value) {

                    if (value != null) {

                      context.read<OnlineDoctorSpecialityBloc>().add(
                        FetchDoctorsBySpecialityEvent(
                          specialityId: value,
                          language: widget.language,
                        ),
                      );
                    }
                  },
                ),
              ),

              /// DOCTOR LIST
              Expanded(
                child: ListView.builder(

                  controller: _scrollController,
                  padding: const EdgeInsets.all(12),

                 // itemCount: state.doctors.length,
                  itemCount: state.doctors.length + (state.isPaginationLoading ? 1 : 0),

                  itemBuilder: (context, index) {
                    /// Pagination Loader
                    if (index >= state.doctors.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final doctor = state.doctors[index];

                    double rating =
                        double.tryParse(doctor.rating.toString()) ?? 0;

                    return InkWell(

                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorDetailsScreen(doctor: doctor),
                          ),
                        );
                      },

                      child: Container(

                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black12,
                            )
                          ],
                        ),

                        child: Row(
                          children: [

                            /// IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (doctor.image.isEmpty || doctor.image == "null")
                                  ? Image.asset(
                                "assets/logo.png",
                                width: 90,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                                  : Image.network(
                                "${AppUrl.imageBaseUrl}/${doctor.image}",
                                width: 90,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/logo.png",
                                    width: 90,
                                    height: 100,
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

                                  Text(
                                    doctor.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    doctor.specialization,
                                    style: const TextStyle(fontSize: 13),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    doctor.qualification,
                                    style: const TextStyle(fontSize: 13),
                                  ),

                                  const SizedBox(height: 6),

                                  Text(
                                    "${doctor.exp} years experience",
                                    style: const TextStyle(fontSize: 13),
                                  ),

                                  const SizedBox(height: 6),

                                  Row(
                                    children: List.generate(5, (i) {

                                      return Icon(
                                        i < rating.round()
                                            ? Icons.star
                                            : Icons.star_border,
                                        size: 16,
                                        color: Colors.orange,
                                      );
                                    }),
                                  ),

                                  const SizedBox(height: 8),

                                  SizedBox(
                                    height: 36,
                                    child: ElevatedButton(

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),

                                      onPressed: () {},

                                      child: const Text(
                                        "Online Consult",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
