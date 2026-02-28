import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medryder/bloc/post_address_bloc/post_address_bloc.dart';
import 'package:medryder/bloc/post_address_bloc/post_address_state.dart';
import 'package:medryder/config/colors/app_colors.dart';

import '../../bloc/post_address_bloc/post_address_event.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {

  final TextEditingController addressController = TextEditingController();
  final TextEditingController houseController = TextEditingController();
  final TextEditingController buildingController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();

  double? latitude;
  double? longitude;

  String stateName = "";
  String cityName = "";
  String pinCode = "";

  String addressType = "Home";

  /// ================= GET LOCATION =================
  Future<void> _getCurrentLocation() async {

    LocationPermission permission =
    await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission denied")),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude = position.latitude;
    longitude = position.longitude;

    List<Placemark> placemarks =
    await placemarkFromCoordinates(
        position.latitude, position.longitude);

    Placemark place = placemarks.first;

    stateName = place.administrativeArea ?? "";
    cityName = place.locality ?? "";
    pinCode = place.postalCode ?? "";

    String fullAddress =
        "${place.name}, ${place.thoroughfare}, "
        "${place.subLocality}, ${place.locality}, "
        "${place.administrativeArea}, ${place.postalCode}";

    setState(() {
      addressController.text = fullAddress;
    });
  }

  /// ================= COMMON TEXTFIELD =================
  Widget _textField(String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  /// ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        title: const Text(
          "Add Address",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: AppColors.whiteColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      /// ================= BUTTON =================
      bottomNavigationBar:
      BlocConsumer<PostAddressBloc, PostAddressState>(
        listener: (context, state) {

          if (state.status == PostAddressStatus.success) {

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );

            Future.delayed(const Duration(milliseconds: 300), () {
              Navigator.pop(context);
            });
          }

          if (state.status == PostAddressStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },

        builder: (context, blocState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                blocState.status == PostAddressStatus.loading
                    ? null
                    : () {

                  /// LOCATION VALIDATION
                  if (latitude == null ||
                      longitude == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Please select location")),
                    );
                    return;
                  }

                  /// FIRE EVENT
                  context
                      .read<PostAddressBloc>()
                      .add(
                    SubmitAddressEvent(
                      address:
                      addressController.text,
                      hno: houseController.text,
                      buildingNo:
                      buildingController.text,
                      landmark:
                      landmarkController.text,
                      lat: latitude.toString(),
                      lon: longitude.toString(),
                      state: stateName,
                      city: cityName,
                      pincode: pinCode,
                      addressType: addressType,
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightblue,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                ),

                child: blocState.status ==
                    PostAddressStatus.loading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  "Confirm Address",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Address + Location Picker
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: "Address",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.my_location,
                      color: Colors.blue),
                  onPressed: _getCurrentLocation,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text("House No"),
            ),
            _textField("Enter house number", houseController),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Building / Block"),
            ),
            _textField("Enter building", buildingController),

            Align(
              alignment: Alignment.centerLeft,
              child: const Text("Landmark"),
            ),
            _textField("Enter landmark", landmarkController),
          ],
        ),
      ),
    );
  }
}