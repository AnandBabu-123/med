import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/diagnostic_test_event/diagnostic_tests_bloc.dart';
import '../../bloc/diagnostic_test_event/diagnostic_tests_event.dart';
import '../../bloc/diagnostic_test_event/diagnostic_tests_state.dart';

class DiagnosticTestsScreen extends StatefulWidget {
  final int diagnosticId;
  final String language;

  const DiagnosticTestsScreen({
    super.key,
    required this.diagnosticId,
    required this.language,
  });

  @override
  State<DiagnosticTestsScreen> createState() => _DiagnosticTestsScreenState();
}

class _DiagnosticTestsScreenState extends State<DiagnosticTestsScreen> {

  /// CART LIST
  List cart = [];

  /// TOTAL PRICE
  double totalPrice = 0;

  @override
  void initState() {
    super.initState();

    context.read<DiagnosticTestsBloc>().add(
      FetchDiagnosticTests(
        diagnosticId: widget.diagnosticId,
        page: 1,
        language: widget.language,
      ),
    );
  }

  /// ADD TO CART
  void addToCart(test) {

    if (!cart.contains(test)) {
      cart.add(test);

      totalPrice += double.parse(test.discountPrice.toString());
    }

    setState(() {});
  }

  /// REMOVE CART
  void removeFromCart(test) {

    cart.remove(test);

    totalPrice -= double.parse(test.discountPrice.toString());

    setState(() {});
  }

  /// ===================== UI ======================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// APPBAR
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Diagnostic Tests",
          style: TextStyle(color: Colors.white),
        ),
      ),

      /// BOTTOM CART BAR
      bottomNavigationBar: cart.isEmpty
          ? const SizedBox()
          : Container(
        height: 65,
        padding: const EdgeInsets.symmetric(horizontal: 16),

        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
            )
          ],
        ),

        child: Row(
          children: [

            /// TOTAL PRICE
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Total",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),

                Text(
                  "₹$totalPrice",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// CONTINUE BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                    horizontal: 25, vertical: 12),
              ),
              onPressed: () {},

              child: const Text(
                "Continue",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),

      /// BODY
      body: BlocBuilder<DiagnosticTestsBloc, DiagnosticTestsState>(
        builder: (context, state) {

          if (state.status == DiagnosticTestsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.list.isEmpty) {
            return const Center(child: Text("No Tests Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.list.length,
            itemBuilder: (_, index) {

              final test = state.list[index];

              bool isAdded = cart.contains(test);

              return GestureDetector(

                /// OPEN BOTTOM SHEET
                onTap: () {
                  _showTestDetails(test);
                },

                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 8,
                      )
                    ],
                  ),

                  child: Row(
                    children: [

                      /// IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://medconnect.org.in/bharosa/${test.image}",
                          width: 65,
                          height: 65,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// DETAILS
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              test.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [

                                const Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 5),

                                Text(
                                  "Report in ${test.reportIn} hrs",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            /// PRICE
                            Row(
                              children: [

                                Text(
                                  "₹${test.discountPrice}",
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(width: 6),

                                Text(
                                  "₹${test.price}",
                                  style: const TextStyle(
                                    decoration:
                                    TextDecoration.lineThrough,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      /// BOOK BUTTON
                      ElevatedButton(

                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isAdded ? Colors.grey : Colors.blue,
                        ),

                        onPressed: () {

                          if (isAdded) {
                            removeFromCart(test);
                          } else {
                            addToCart(test);
                          }
                        },

                        child: Text(
                          isAdded ? "Added" : "Book",
                          style: const TextStyle(color: Colors.white),
                        ),
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

  /// ================= BOTTOM SHEET =================

  void _showTestDetails(test) {

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
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * .65,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// TITLE
              Text(
                test.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [

                  Text(
                    "₹${test.discountPrice}",
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    "₹${test.price}",
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              const Text(
                "Tests Included",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: ListView.builder(
                  itemCount: test.tests.length,
                  itemBuilder: (_, i) {

                    final mainTest = test.tests[i];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          mainTest.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        ...mainTest.subTests.map(
                              (sub) => Padding(
                            padding: const EdgeInsets.only(
                                left: 10, bottom: 4),

                            child: Row(
                              children: [

                                const Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: Colors.grey,
                                ),

                                const SizedBox(width: 6),

                                Text(sub.name),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}