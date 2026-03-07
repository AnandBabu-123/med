import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/lab_bloc/lab_bloc.dart';
import '../../bloc/lab_bloc/lab_event.dart';
import '../../bloc/lab_bloc/lab_state.dart';
import '../../models/lab_test_models/lab_model.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/get_address_repository/family_count_repository.dart';

class LabTestScreen extends StatefulWidget {

  final int labTestId;
  final String language;

  const LabTestScreen({
    super.key,
    required this.labTestId,
    required this.language,
  });

  @override
  State<LabTestScreen> createState() => _LabTestScreenState();
}

class _LabTestScreenState extends State<LabTestScreen> {

  /// STORE SELECTED PACKAGES
  List<LabPackage> selectedPackages = [];

  @override
  void initState() {
    super.initState();

    context.read<LabBloc>().add(
      FetchLabTests(widget.labTestId),
    );
  }

  /// TOTAL PRICE
  int getTotalPrice() {
    int total = 0;

    for (var item in selectedPackages) {
      total += item.discount;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("Lab Tests"),
      ),

      /// BOTTOM BAR
      bottomNavigationBar: selectedPackages.isEmpty
          ? null
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            /// PRICE LEFT
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  "₹${getTotalPrice()}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),

                Text(
                  "${selectedPackages.length} items selected",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),

            /// CONTINUE BUTTON
            ElevatedButton(
              onPressed: () {

                /// DO NOT NAVIGATE
                /// HANDLE BOOKING HERE

                print("Selected package IDs:");
                print(selectedPackages.map((e) => e.id).toList());

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Proceeding with booking"),
                  ),
                );

              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Continue"),
            )
          ],
        ),
      ),

      body: BlocBuilder<LabBloc, LabState>(
        builder: (context, state) {

          if (state.status == LabStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == LabStatus.failure) {
            return const Center(child: Text("Failed to load tests"));
          }

          return ListView.builder(
            itemCount: state.packages.length,
            itemBuilder: (context, index) {

              final package = state.packages[index];

              bool isSelected =
              selectedPackages.any((e) => e.id == package.id);

              return GestureDetector(

                /// OPEN DETAILS
                onTap: () {
                  showTestBottomSheet(package);
                },

                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black.withOpacity(.05),
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// NAME
                      Text(
                        package.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text("Report in ${package.reportIn}"),

                      const SizedBox(height: 6),

                      Text("Fasting: ${package.fasting}"),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          /// PRICE
                          Row(
                            children: [

                              Text(
                                "₹${package.discount}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                "₹${package.price}",
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          ElevatedButton(
                              onPressed: () async {

                                final repo = FamilyCountRepository(
                                  DioClient(
                                    dio: Dio(),
                                    networkInfo: NetworkInfo(),
                                  ),
                                );

                                try {

                                  final result = await repo.getFamilyCount();

                                  print("Family Count: ${result.response.count}");

                                  if (result.response.count == 0) {

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please add family member first"),
                                      ),
                                    );

                                  } else {

                                    print("Proceed booking");

                                  }

                                } catch (e) {

                                  print(e);

                                }

                              },
                            child: const Text("Continue"),
                          )

                          /// BOOK BUTTON
                          // ElevatedButton(
                          //
                          //   onPressed: () {
                          //
                          //     setState(() {
                          //
                          //       if (isSelected) {
                          //         selectedPackages.removeWhere(
                          //                 (e) => e.id == package.id);
                          //       } else {
                          //         selectedPackages.add(package);
                          //       }
                          //
                          //     });
                          //
                          //   },
                          //
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: isSelected
                          //         ? Colors.red
                          //         : Colors.blue,
                          //   ),
                          //
                          //   child: Text(
                          //     isSelected ? "Remove" : "Book",
                          //   ),
                          // )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// TEST DETAILS BOTTOM SHEET (NO CONTINUE BUTTON)
  void showTestBottomSheet(LabPackage package) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),

      builder: (_) {

        return Container(
          height: MediaQuery.of(context).size.height * .6,
          padding: const EdgeInsets.all(16),

          child: ListView(

            children: [

              Text(
                package.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              ...package.tests.map((test) {

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      test.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    ...test.subTests.map((sub) {

                      return Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text("• ${sub.name}"),
                      );

                    }),

                    const SizedBox(height: 12),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
