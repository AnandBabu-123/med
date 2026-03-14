import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/doctor_coupon_bloc/doctor_coupon_bloc.dart';
import '../../bloc/doctor_coupon_bloc/doctor_coupon_event.dart';
import '../../bloc/doctor_coupon_bloc/doctor_coupon_state.dart';
import '../../config/colors/app_colors.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/online_doctors_repository/online_doctor_coupon_repository.dart';

class OffersScreen extends StatelessWidget {

  final int specialityId;

  const OffersScreen({super.key, required this.specialityId});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Available Offers",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.white,
              fontSize: 20,
            ),
        ),
      ),

      body: BlocProvider(
        create: (context) => DoctorCouponBloc(
          OnlineDoctorCouponRepository(
            DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
            ),
          ),
        )..add(
          FetchDoctorCouponsEvent(
            specialityId: specialityId,
          ),
        ),

        child: BlocBuilder<DoctorCouponBloc, DoctorCouponState>(
          builder: (context, state) {

            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.coupons.isEmpty) {
              return const Center(child: Text("No Offers Available"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.coupons.length,

              itemBuilder: (context, index) {

                final coupon = state.coupons[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// First Row (Name + Percentage + Apply)

                      Row(
                        children: [

                          Expanded(
                            child: Text(
                              coupon.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),

                          Text(
                            "${coupon.percentage}% OFF",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(width: 10),

                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context, coupon);
                            },

                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.blue),
                              ),

                              child: const Text(
                                "APPLY",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      /// Description

                      Text(
                        coupon.description,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}