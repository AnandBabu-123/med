
import 'package:flutter/material.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/app_url.dart';
import '../../models/online_doctors_model/online_booking_response.dart';
import '../../models/online_doctors_model/online_doctor_coupon_model.dart';
import '../../models/online_doctors_model/online_doctor_speciality_model.dart';
import 'offer_screen.dart';

class DoctorSummaryScreen extends StatefulWidget {
  final Doctor doctor;
  final Slots slot;
  final FamilyMember patient;

  const DoctorSummaryScreen({
    super.key,
    required this.doctor,
    required this.slot,
    required this.patient,
  });

  @override
  State<DoctorSummaryScreen> createState() => _DoctorSummaryScreenState();
}

class _DoctorSummaryScreenState extends State<DoctorSummaryScreen> {

  Coupon? selectedCoupon;
  final TextEditingController couponController = TextEditingController();

  double getTotalPrice() {
    if (selectedCoupon == null) {
      return widget.doctor.fee.toDouble();
    }

    final discount =
        widget.doctor.fee * selectedCoupon!.percentage / 100;

    return widget.doctor.fee - discount;
  }

  @override
  Widget build(BuildContext context) {

    final totalPrice = getTotalPrice();

    return Scaffold(

      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Booking Summary",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),

        child: SafeArea(
          child: Row(
            children: [

              /// Price

              Text(
                "₹$totalPrice",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              /// Pay Button

              SizedBox(
                height: 48,
                width: 140,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  onPressed: () {},

                  child: const Text(
                    "Pay Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            /// Doctor Card

            Row(
              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(8),

                  child: Image.network(
                    "${AppUrl.imageBaseUrl}/${widget.doctor.image}",
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

                    Text(widget.doctor.specialization),

                    Text("${widget.doctor.exp} years exp"),
                  ],
                )
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Appointment Time",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text("${widget.slot.date} | ${widget.slot.time}"),

            const SizedBox(height: 20),

            const Text(
              "Patient",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(widget.patient.name),

            const SizedBox(height: 20),

            /// Coupon Field

            TextField(
              controller: couponController,
              readOnly: true,

              decoration: InputDecoration(
                hintText: "Apply Offer",
                border: const OutlineInputBorder(),

                suffixIcon: TextButton(
                  child: const Text("View"),

                  onPressed: () async {

                    final coupon = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OffersScreen(
                          specialityId:
                          widget.doctor.specialityId,
                        ),
                      ),
                    );

                    if (coupon != null) {

                      setState(() {

                        selectedCoupon = coupon;

                        couponController.text =
                            coupon.name;
                      });
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            const TextField(
              decoration: InputDecoration(
                hintText: "Contact Number",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,

              children: [

                const Text(
                  "Consultation Fee",
                  style: TextStyle(fontSize: 16),
                ),

                Text(
                  "₹${widget.doctor.fee}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            if (selectedCoupon != null)

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  Text("${selectedCoupon!.percentage}% OFF"),

                  Text(
                    "-₹${widget.doctor.fee * selectedCoupon!.percentage / 100}",
                    style: const TextStyle(
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}