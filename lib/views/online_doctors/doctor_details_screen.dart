import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/online_doctor_booking_bloc/doctor_booking_bloc.dart';
import '../../bloc/online_doctor_booking_bloc/doctor_booking_event.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/app_url.dart';
import '../../models/online_doctors_model/online_doctor_speciality_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/online_doctors_repository/online_doctor_dates_repository.dart';
import '../../repository/online_doctors_repository/online_doctor_repository.dart';
import 'doctor_dates_booking.dart';

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Doctor's Profile",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
            fontSize: 20,
          ),
        ),
      ),

      /// Bottom Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightblue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => DoctorBookingBloc(
                      OnlineDoctorDatesRepository(
                        DioClient(
                          dio: Dio(),
                          networkInfo: NetworkInfo(),
                        ),
                      ),
                    )..add(
                      FetchDoctorDatesEvent(
                        language: "",
                        specialityId: doctor.specialityId,
                        doctorId: doctor.id,
                          fee: doctor.fee
                      ),
                    ),
                    child: DoctorBookingScreen(
                      doctor: doctor,
                    ),
                  ),
                ),
              );
            },
            child: const Text(
              "Online Consult",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ---------------- DOCTOR PROFILE CONTAINER ----------------
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.06),
                    blurRadius: 6,
                    offset: const Offset(0,3),
                  )
                ],
              ),

              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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

                        /// NAME
                        Text(
                          doctor.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// SPECIALIZATION
                        Text(
                          doctor.specialization,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// QUALIFICATION
                        Text(
                          doctor.qualification,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// EXPERIENCE
                        Text(
                          "${doctor.exp} years experience",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),

                        const SizedBox(height: 6),

                        /// RATING
                        Row(
                          children: [
                            ...List.generate(5, (i) {
                              return Icon(
                                i < double.parse(doctor.rating).round()
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.orange,
                                size: 18,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ---------------- DESCRIPTION ----------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 5,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "About Doctor",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    doctor.description.isEmpty
                        ? "No description available"
                        : doctor.description,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// ---------------- CONSULTATION FEE ----------------
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 5,
                  )
                ],
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Consultation Fee",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  Text(
                    "₹${doctor.fee}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
