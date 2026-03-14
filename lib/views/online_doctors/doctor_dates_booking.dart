import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/views/online_doctors/patient_details_screen.dart';

import '../../bloc/online_doctor_booking_bloc/doctor_booking_bloc.dart';
import '../../bloc/online_doctor_booking_bloc/doctor_booking_event.dart';
import '../../bloc/online_doctor_booking_bloc/doctor_booking_state.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/app_url.dart';
import '../../models/online_doctors_model/online_booking_response.dart';
import '../../models/online_doctors_model/online_doctor_speciality_model.dart';


class DoctorBookingScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorBookingScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorBookingScreen> createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {

  String? selectedDate;
  Slots? selectedSlot;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
            "Book Appointment",

            style: TextStyle(fontWeight: FontWeight.w500,color: AppColors.whiteColor,fontSize: 20)
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            onPressed: selectedSlot == null
                ? null
                : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientDetailsScreen(
                    doctor: widget.doctor,
                    slot: selectedSlot!,
                    familyMembers: context
                        .read<DoctorBookingBloc>()
                        .state
                        .familyMembers,
                  ),
                ),
              );
            },
            child: const Text(
              "Confirm Appointment",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),

      body: BlocBuilder<DoctorBookingBloc, DoctorBookingState>(
        builder: (context, state) {

          if (state.isLoading && state.dates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                /// ---------------- DOCTOR INFO ----------------

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: (widget.doctor.image.isEmpty || widget.doctor.image == "null")
                            ? Image.asset(
                          "assets/logo.png",
                          width: 90,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          "${AppUrl.imageBaseUrl}/${widget.doctor.image}",
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

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            widget.doctor.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(widget.doctor.specialization),

                          const SizedBox(height: 4),

                          Text("${widget.doctor.exp} years experience"),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------------- SELECT DATE ----------------

                const Text(
                  "Select Date",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  height: 50,
                  child: ListView.builder(

                    scrollDirection: Axis.horizontal,
                    itemCount: state.dates.length,

                    itemBuilder: (context, index) {

                      final date = state.dates[index];

                      final isSelected =
                          selectedDate == date.date;

                      return GestureDetector(

                        onTap: () {

                          setState(() {
                            selectedDate = date.date;
                            selectedSlot = null;
                          });

                          context.read<DoctorBookingBloc>().add(
                            FetchDoctorSlotsEvent(
                              language: "en",
                              specialityId: widget.doctor.specialityId,
                              doctorId: widget.doctor.id,
                              date: date.date,
                              fee: widget.doctor.fee
                            ),
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(right: 10),

                          padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10),

                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                : Colors.white,

                            borderRadius: BorderRadius.circular(8),

                            border: Border.all(
                              color: Colors.blue,
                            ),
                          ),

                          child: Center(
                            child: Text(
                              date.formatDate,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// ---------------- SLOTS ----------------

                if (state.slots != null) ...[

                  _buildSession("Morning", state.slots!.morning),

                  _buildSession("Afternoon", state.slots!.afternoon),

                  _buildSession("Evening", state.slots!.evening),

                ],
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// SLOT SESSION UI

  Widget _buildSession(
      String title,
      List<Slots> slots,
      )
  {

    if (slots.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 20),

        Row(
          children: [
            Icon(
              title == "Morning"
                  ? Icons.wb_sunny
                  : title == "Afternoon"
                  ? Icons.wb_cloudy
                  : Icons.nights_stay,
              size: 18,
              color: Colors.orange,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: slots.map((slot) {

            final isSelected =
                selectedSlot?.id == slot.id;

            final isBooked =
                slot.bookingStatus != "available";

            return GestureDetector(

              onTap: isBooked
                  ? null
                  : () {
                setState(() {
                  selectedSlot = slot;
                });
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),

                decoration: BoxDecoration(

                  color: isSelected
                      ? Colors.blue
                      : isBooked
                      ? Colors.grey.shade300
                      : Colors.white,

                  borderRadius: BorderRadius.circular(8),

                  border: Border.all(
                    color: isSelected
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                ),

                child: Text(
                  slot.time,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : isBooked
                        ? Colors.grey
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
