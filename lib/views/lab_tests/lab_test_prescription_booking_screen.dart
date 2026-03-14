import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../bloc/lab_booking_bloc/lab_booking_bloc.dart';
import '../../bloc/lab_booking_bloc/lab_booking_event.dart';
import '../../bloc/lab_booking_bloc/lab_booking_state.dart';
import '../../config/routes/app_url.dart';

class LabTestPrescriptionBookingScreen extends StatefulWidget {

  final int labTestId;
  final int testId;
  final int price;
  final String name;
  final String image;

  const LabTestPrescriptionBookingScreen({
    super.key,
    required this.labTestId,
    required this.testId,
    required this.price,
    required this.name,
    required this.image,
  });

  @override
  State<LabTestPrescriptionBookingScreen> createState() =>
      _LabTestPrescriptionBookingScreenState();
}

class _LabTestPrescriptionBookingScreenState
    extends State<LabTestPrescriptionBookingScreen> {

  String? selectedDate;

  @override
  void initState() {
    super.initState();

    /// Load dates API
    context.read<LabBookingBloc>().add(
      LoadDatesEvent(
        widget.labTestId,
        widget.testId,
        widget.price,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Prescription Booking"),
      ),

      body: BlocBuilder<LabBookingBloc, LabBookingState>(
        builder: (context, state) {

          if (state is LabBookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DatesLoaded || state is SlotsLoaded) {

            final model = state is DatesLoaded
                ? state.model
                : (state as SlotsLoaded).model;

            final dates = model.response.dates ?? [];
            final slots = model.response.slots;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// --------------------------
                  /// PACKAGE DETAILS
                  /// --------------------------

                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [

                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: (widget.image.isEmpty || widget.image == "null")
                              ? Image.asset(
                            "assets/logo.png",
                            width: 70,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            "${AppUrl.imageBaseUrl}/${widget.image}",
                            width: 70,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                "assets/logo.png",
                                width: 70,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(
                                widget.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                "₹${widget.price}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(),

                  /// --------------------------
                  /// SELECT DATE
                  /// --------------------------

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Select Date",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: dates.length,
                      itemBuilder: (context, index) {

                        final date = dates[index];

                        final isSelected =
                            selectedDate == date.date;

                        return GestureDetector(
                          onTap: () {

                            setState(() {
                              selectedDate = date.date;
                            });

                            /// LOAD SLOTS
                            context.read<LabBookingBloc>().add(
                              LoadSlotsEvent(
                                widget.labTestId,
                                widget.testId,
                                widget.price,
                                date.date,
                              ),
                            );
                          },

                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.white,
                              borderRadius:
                              BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade300),
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

                  /// --------------------------
                  /// SLOTS
                  /// --------------------------

                  if (slots != null) ...[

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Available Slots",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// MORNING

                    if (slots.morning.isNotEmpty)
                      _buildSlotSection(
                        "Morning",
                        slots.morning,
                      ),

                    /// AFTERNOON

                    if (slots.afternoon.isNotEmpty)
                      _buildSlotSection(
                        "Afternoon",
                        slots.afternoon,
                      ),

                    /// EVENING

                    if (slots.evening.isNotEmpty)
                      _buildSlotSection(
                        "Evening",
                        slots.evening,
                      ),
                  ]
                ],
              ),
            );
          }

          if (state is LabBookingError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  /// SLOT SECTION UI

  Widget _buildSlotSection(String title, List slots) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: slots.map<Widget>((slot) {

              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(slot.time),
              );

            }).toList(),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
