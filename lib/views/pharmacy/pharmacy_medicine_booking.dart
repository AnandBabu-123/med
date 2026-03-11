import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/pharmacy_ongoing_orders_bloc/pharmacy_ongoing_orders_bloc.dart';
import 'package:medryder/bloc/pharmacy_ongoing_orders_bloc/pharmacy_ongoing_orders_state.dart';

import '../../bloc/pharmacy_ongoing_orders_bloc/pharmacy_ongoing_orders_event.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/app_url.dart';

class PharmacyMedicineBooking extends StatefulWidget {

  final String language;

  const PharmacyMedicineBooking({
    super.key,
    required this.language,
  });

  @override
  State<PharmacyMedicineBooking> createState() =>
      _PharmacyMedicineBookingState();
}

class _PharmacyMedicineBookingState
    extends State<PharmacyMedicineBooking>
    with SingleTickerProviderStateMixin {

  late TabController tabController;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 2, vsync: this);

    context.read<PharmacyOngoingOrdersBloc>().add(
      LoadOngoingOrders(
        language: widget.language,
        page: 1,
      ),
    );

    scrollController.addListener(_onScroll);
  }

  void _onScroll() {

    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {

      final bloc = context.read<PharmacyOngoingOrdersBloc>();
      final state = bloc.state;

      if (!state.hasReachedMax) {

        bloc.add(
          LoadOngoingOrders(
            language: widget.language,
            page: state.page + 1,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Pharmacy Orders",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.whiteColor,
            fontSize: 20,
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.white, // WHITE GAP BELOW APPBAR
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.lightblue.withOpacity(0.15), // tab background
                borderRadius: BorderRadius.circular(6),
              ),

              child: TabBar(
                controller: tabController,

                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                indicatorColor: Colors.transparent,

                indicator: BoxDecoration(
                  color: AppColors.lightblue, // selected tab
                  borderRadius: BorderRadius.circular(6),
                ),

                labelColor: Colors.white,
                unselectedLabelColor: AppColors.lightblue,

                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),

                tabs: const [
                  Tab(text: "OnGoing Orders"),
                  Tab(text: "Completed Orders"),
                ],
              ),
            ),
          ),
        ),
      ),

      body: TabBarView(
        controller: tabController,
        children: [

          /// ONGOING ORDERS
          BlocBuilder<PharmacyOngoingOrdersBloc, PharmacyOngoingOrdersState>(
            builder: (context, state) {

              if (state.isLoading && state.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.orders.isEmpty) {
                return const Center(child: Text("No Orders"));
              }

              return ListView.builder(
                controller: scrollController,
                itemCount: state.orders.length,
                itemBuilder: (context, index) {

                  final order = state.orders[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// IMAGE
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "${AppUrl.imageBaseUrl}/${order.image}",
                              height: 70,
                              width: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image, size: 70);
                              },
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// ORDER DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// HOSPITAL NAME
                                Text(
                                  order.hospitalName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                /// BOOKING ID
                                Text(
                                  "Booking ID : ${order.bookingId}",
                                  style: const TextStyle(fontSize: 13),
                                ),

                                const SizedBox(height: 4),

                                /// ORDER TYPE
                                Text(
                                  "Order Type : ${order.orderType}",
                                  style: const TextStyle(fontSize: 13),
                                ),

                                const SizedBox(height: 4),

                                /// BOOKING TYPE
                                Text(
                                  "Booking Type : ${order.bookingType}",
                                  style: const TextStyle(fontSize: 13),
                                ),

                                const SizedBox(height: 4),

                                /// CREATED DATE
                                Text(
                                  "Created On : ${order.createdOn}",
                                  style: const TextStyle(fontSize: 13),
                                ),

                                const SizedBox(height: 6),

                                /// STATUS ROW
                                Row(
                                  children: [

                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        order.bookingStatus,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 8),

                                    if (order.acceptStatus.isNotEmpty)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          order.acceptStatus,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                )
                              ],
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

          /// COMPLETED ORDERS
          const Center(
            child: Text("Completed Orders"),
          ),
        ],
      ),
    );
  }
}