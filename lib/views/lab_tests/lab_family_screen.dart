import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/lab_booking_bloc/lab_booking_bloc.dart';
import '../../bloc/lab_booking_bloc/lab_booking_event.dart';
import '../../models/lab_test_models/lab_booking_model.dart';

class FamilySelectionScreen extends StatefulWidget {

  final int labTestId;
  final int testId;
  final int slotId;
  final int fee;
//  final int count;
  final String date;

  final List<FamilyMember> familyMembers;
  final List<Price> prices;

  const FamilySelectionScreen({
    super.key,
    required this.labTestId,
    required this.testId,
    required this.slotId,
    required this.fee,
 //   required this.count,
    required this.date,
    required this.familyMembers,
    required this.prices,
  });

  @override
  State<FamilySelectionScreen> createState() =>
      _FamilySelectionScreenState();
}
class _FamilySelectionScreenState extends State<FamilySelectionScreen> {

  List<int> selectedMembers = [];
  Price? selectedPrice;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Select Family Members"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// FAMILY MEMBERS
            const Text(
              "Family Members",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(

                itemCount: widget.familyMembers.length,

                itemBuilder: (context, index) {

                  final member = widget.familyMembers[index];
                  final isSelected =
                  selectedMembers.contains(member.id);

                  return Card(

                    child: CheckboxListTile(

                      title: Text(member.name),
                      subtitle: Text(member.type),

                      value: isSelected,

                      onChanged: (value) {

                        setState(() {

                          if (value == true) {
                            selectedMembers.add(member.id);
                          } else {
                            selectedMembers.remove(member.id);
                          }

                        });

                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            /// PATIENT PRICE
            const Text(
              "Select Patient Count",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Column(
              children: widget.prices.map((price) {

                final isSelected =
                    selectedPrice?.patientCount ==
                        price.patientCount;

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
                        color: isSelected
                            ? Colors.blue
                            : Colors.grey.shade300,
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
                          child: Text(
                            "${price.patientCount} Patient",
                          ),
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

            const SizedBox(height: 20),

            /// CONTINUE BUTTON
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  if (selectedMembers.isEmpty) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Select at least one member"),
                      ),
                    );

                    return;
                  }

                  if (selectedPrice == null) {

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Select patient count"),
                      ),
                    );

                    return;
                  }

                  print("Selected Members: $selectedMembers");
                  print("Selected Price: ${selectedPrice!.discountPrice}");
                },

                child: const Text("Continue"),
              ),
            ),

          ],
        ),
      ),
    );
  }
}