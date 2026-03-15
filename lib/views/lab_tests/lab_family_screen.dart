import 'package:flutter/material.dart';
import '../../config/colors/app_colors.dart';
import '../../models/lab_test_models/lab_booking_model.dart';

import 'package:flutter/material.dart';

import 'lab_summary_screen.dart';

class FamilySelectionScreen extends StatefulWidget {
  final int labTestId;
  final int testId;
  final int slotId;
  final int fee;
  final String date;
  final String image;

  final List<FamilyMembers> familyMembers;
  final List<Prices> prices;

  const FamilySelectionScreen({
    super.key,
    required this.labTestId,
    required this.testId,
    required this.slotId,
    required this.fee,
    required this.date,
    required this.familyMembers,
    required this.prices,
    required this.image
  });

  @override
  State<FamilySelectionScreen> createState() => _FamilySelectionScreenState();
}

class _FamilySelectionScreenState extends State<FamilySelectionScreen> {
  List<int> selectedMembers = [];
  Prices? selectedPrice;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Family Members",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// FAMILY MEMBERS
            const Text(
              "Family Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.familyMembers.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemBuilder: (context, index) {
                final member = widget.familyMembers[index];
                final isSelected = selectedMembers.contains(member.id);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedMembers.remove(member.id);
                      } else {
                        selectedMembers.add(member.id);
                      }
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                      isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Text(
                      member.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            /// PATIENT COUNT
            const Text(
              "Select Patient Count",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Column(
              children: widget.prices.map((price) {
                final isSelected =
                    selectedPrice?.patientCount == price.patientCount;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPrice = price;
                      selectedMembers.clear();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
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

                        Radio<Prices>(
                          value: price,
                          groupValue: selectedPrice,
                          onChanged: (value) {
                            setState(() {
                              selectedPrice = value;
                              selectedMembers.clear();
                            });
                          },
                        ),

                        Expanded(
                          child: Text(
                            "${price.patientCount} Patient",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            /// Original price
                            Text(
                              "₹${price.price}",
                              style: const TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),

                            /// Discount price
                            Text(
                              "₹${price.discountPrice}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            /// CONTINUE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {

                    if (selectedPrice == null) {
                      _showMsg("Select patient count");
                      return;
                    }

                    if (selectedMembers.isEmpty) {
                      _showMsg("Select family member");
                      return;
                    }

                    if (selectedMembers.length != selectedPrice!.patientCount) {
                      _showMsg("Please select ${selectedPrice!.patientCount} members");
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LabSummaryScreen(
                          labTestId: widget.labTestId,
                          testId: widget.testId,
                          slotId: widget.slotId,
                          date: widget.date,
                          fee: widget.fee,
                          selectedMembers: selectedMembers,
                          patientCount: selectedPrice!.patientCount,
                          price: selectedPrice!.discountPrice,
                          image: widget.image,
                        ),
                      ),
                    );
                  },
                child: const Text("Continue"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}