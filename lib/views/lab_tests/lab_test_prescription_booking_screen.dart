import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/views/lab_tests/lab_family_screen.dart';
import '../../bloc/lab_booking_bloc/lab_booking_bloc.dart';
import '../../bloc/lab_booking_bloc/lab_booking_event.dart';
import '../../bloc/lab_booking_bloc/lab_booking_state.dart';
import '../../models/lab_test_models/lab_booking_model.dart';
import '../../utils/session_manager.dart';

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
  Slot? selectedSlot;
  FamilyMember? selectedFamilyMember;
  Price? selectedPrice;

  @override
  void initState() {
    super.initState();

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
        title: const Text("Lab Test Booking"),
      ),

      bottomNavigationBar: BlocBuilder<LabBookingBloc, LabBookingState>(
        builder: (context, state) {

          return Padding(
            padding: const EdgeInsets.all(16),

            child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onPressed: () {

                /// DATE CHECK
                if (selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select date")),
                  );
                  return;
                }

                /// SLOT CHECK
                if (selectedSlot == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please select slot")),
                  );
                  return;
                }



                /// NAVIGATION
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FamilySelectionScreen(
                      labTestId: widget.labTestId,
                      testId: widget.testId,
                      slotId: selectedSlot!.id,
                      fee: widget.price,
                   //   count: selectedPrice!.patientCount,
                      date: selectedDate!,
                      familyMembers: state.familyMembers,
                      prices: state.prices,
                    ),
                  ),
                );
              },

              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          );
        },
      ),

      body: BlocBuilder<LabBookingBloc, LabBookingState>(
        builder: (context, state) {

          if (state.isLoading && state.dates.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(

            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ADDRESS
                _addressCard(),

                const SizedBox(height: 20),

                /// DATE SELECTOR
                _dateSelector(state),

                const SizedBox(height: 20),

                /// SLOTS (ONLY WHEN DATE SELECTED)
                if (state.slots != null) ...[
                  _buildSession("Morning", state.slots!.morning),
                  _buildSession("Afternoon", state.slots!.afternoon),
                  _buildSession("Evening", state.slots!.evening),
                ],

                const SizedBox(height: 25),

                /// FAMILY MEMBERS (ALWAYS SHOW)
                if (state.familyMembers.isNotEmpty)
                  _familyDropdown(state),

                const SizedBox(height: 20),

                /// PATIENT SELECTION (ALWAYS SHOW)
                if (state.prices.isNotEmpty)
                  _patientSelection(state),
              ],
            ),
          );
        },
      ),
    );
  }

  /// ADDRESS
  Widget _addressCard() {

    return FutureBuilder<String?>(
      future: SessionManager.getAddress(),
      builder: (context, snapshot) {

        final address = snapshot.data ?? "No address";

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 5)
            ],
          ),

          child: Row(
            children: [

              const Icon(Icons.location_on, color: Colors.blue),

              const SizedBox(width: 10),

              Expanded(child: Text(address)),

              const Icon(Icons.edit_location_alt),
            ],
          ),
        );
      },
    );
  }

  /// DATE SELECTOR
  Widget _dateSelector(LabBookingState state) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Select Date",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 50,

          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.dates.length,

            itemBuilder: (context, index) {

              final date = state.dates[index];
              final isSelected = selectedDate == date.date;

              return GestureDetector(

                onTap: () {

                  setState(() {
                    selectedDate = date.date;
                    selectedSlot = null;
                  });

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
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),

                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue),
                  ),

                  child: Center(
                    child: Text(
                      date.formatDate,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// FAMILY DROPDOWN
  Widget _familyDropdown(LabBookingState state) {

    return DropdownButtonFormField<FamilyMember>(
      value: selectedFamilyMember,

      decoration: const InputDecoration(
        labelText: "Select Family Member",
        border: OutlineInputBorder(),
      ),

      items: state.familyMembers.map((member) {

        return DropdownMenuItem(
          value: member,
          child: Text(member.name),
        );

      }).toList(),

      onChanged: (value) {

        setState(() {
          selectedFamilyMember = value;
        });

      },
    );
  }

  /// PATIENT SELECTION
  Widget _patientSelection(LabBookingState state) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Select Patients",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Column(
          children: state.prices.map((price) {

            final isSelected =
                selectedPrice?.patientCount == price.patientCount;

            return GestureDetector(

              onTap: () {
                setState(() {
                  selectedPrice = price;
                });
              },

              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey,
                  ),
                ),

                child: Row(
                  children: [

                    Radio<Price>(
                      value: price,
                      groupValue: selectedPrice,
                      onChanged: (value) {
                        setState(() {
                          selectedPrice = value;
                        });
                      },
                    ),

                    Expanded(
                      child: Text("${price.patientCount} Patient"),
                    ),

                    Text(
                      "₹${price.discountPrice}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            );

          }).toList(),
        ),
      ],
    );
  }

  /// SLOT UI
  Widget _buildSession(String title, List<Slot> slots) {

    if (slots.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const SizedBox(height: 20),

        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 10,
          runSpacing: 10,

          children: slots.map((slot) {

            final isSelected = selectedSlot?.id == slot.id;
            final isBooked = slot.bookingStatus != "available";

            return GestureDetector(

              onTap: isBooked ? null : () {

                setState(() {
                  selectedSlot = slot;
                });

              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),

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
                        : Colors.grey,
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
                  ),
                ),
              ),
            );

          }).toList(),
        ),
      ],
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}
