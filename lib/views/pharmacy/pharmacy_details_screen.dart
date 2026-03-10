import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';
import '../../bloc/pharmacy_details_bloc/pharmacy_details_bloc.dart';
import '../../bloc/pharmacy_details_bloc/pharmacy_details_event.dart';
import '../../bloc/pharmacy_details_bloc/pharmacy_details_state.dart';
import 'attach_prescription_screen.dart';


class PharmacyDetailsScreen extends StatefulWidget {

  final int pharmacyId;
  final String language;

  const PharmacyDetailsScreen({
    super.key,
    required this.pharmacyId,
    required this.language,
  });

  @override
  State<PharmacyDetailsScreen> createState() =>
      _PharmacyDetailsScreenState();
}

class _PharmacyDetailsScreenState extends State<PharmacyDetailsScreen> {

  static const imageBaseUrl =
      "https://medrayder.in/bharosa/";

  @override
  void initState() {
    super.initState();

    context.read<PharmacyDetailsBloc>().add(
      FetchPharmacyDetails(
        pharmacyId: widget.pharmacyId,
        language: widget.language,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<PharmacyDetailsBloc, PharmacyDetailsState>(
      builder: (context, state) {

        final pharmacy = state.pharmacy;

        return Scaffold(

          /// 🔹 AppBar
          appBar: AppBar(
            backgroundColor: AppColors.lightblue,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: AppColors.whiteColor,),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              pharmacy?.name ?? "Pharmacy Details",
              style: const TextStyle(fontSize: 18,color: AppColors.whiteColor),
            ),
            centerTitle: true,
          ),

          bottomNavigationBar: Container(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.lightblue,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AttachPharmacyPrescriptionScreen(
                      pharmacyId: widget.pharmacyId,
                      language: widget.language,
                    ),
                  ),
                );
              },
              child: const Text(
                "Book Medicine",
                style: TextStyle(fontSize: 16,color: AppColors.whiteColor),
              ),
            ),
          ),

          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(PharmacyDetailsState state) {

    if (state.status == PharmacyDetailsStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == PharmacyDetailsStatus.failure) {
      return Center(child: Text(state.message));
    }

    final pharmacy = state.pharmacy;

    if (pharmacy == null) {
      return const SizedBox();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 Padding above image
          const SizedBox(height: 12),

          /// BIG IMAGE
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageBaseUrl + pharmacy.logo,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// NAME
                Text(
                  pharmacy.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                /// OPEN CLOSE ROW
                Row(
                  children: [

                    const Icon(Icons.access_time,
                        size: 18, color: Colors.grey),

                    const SizedBox(width: 6),

                    Text(
                      "${pharmacy.openTime} - ${pharmacy.closeTime}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// LOCATION
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Icon(Icons.location_on,
                        size: 18, color: Colors.red),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        pharmacy.location,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                /// HOME DELIVERY
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: pharmacy.homeDelivery == "yes"
                        ? Colors.green.shade100
                        : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    pharmacy.homeDelivery == "yes"
                        ? "Home Delivery"
                        : "Pickup Order",
                    style: TextStyle(
                      color: pharmacy.homeDelivery == "yes"
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}