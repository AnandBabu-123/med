import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/online_doctor_booking_bloc/doctor_booking_bloc.dart';
import '../../bloc/online_doctor_booking_bloc/doctor_booking_event.dart';
import '../../bloc/online_doctor_booking_bloc/doctor_booking_state.dart';
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
        title: const Text("Book Appointment"),
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

              /// CONFIRM BOOKING
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
                        child: Image.network(
                          widget.doctor.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
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
                  height: 60,
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
                              date: date.date,
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

                if (state.slots!.isNotEmpty) ...[

                  _buildSession(
                    "Morning",
                    state.slots
                        .where((slot) => slot.session == "Morning")
                        .toList(),
                  ),

                  _buildSession(
                    "Afternoon",
                    state.slots
                        .where((slot) => slot.session == "Afternoon")
                        .toList(),
                  ),

                  _buildSession(
                    "Evening",
                    state.slots
                        .where((slot) => slot.session == "Evening")
                        .toList(),
                  ),
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
      ) {

    if (slots.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const SizedBox(height: 20),

        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          runSpacing: 10,

          children: slots.map((slot) {

            final isSelected =
                selectedSlot?.id == slot.id;

            return GestureDetector(

              onTap: () {

                setState(() {
                  selectedSlot = slot;
                });
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8),

                decoration: BoxDecoration(

                  color: isSelected
                      ? Colors.blue
                      : Colors.white,

                  borderRadius:
                  BorderRadius.circular(8),

                  border: Border.all(
                    color: Colors.blue,
                  ),
                ),

                child: Text(
                  slot.time,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Colors.black,
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
