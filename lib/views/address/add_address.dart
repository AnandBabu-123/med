import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medryder/config/colors/app_colors.dart';

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

  String addressType = "Home";

  ///  Get Exact Location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    /// Convert LatLng → Address
    List<Placemark> placemarks =
    await placemarkFromCoordinates(
        position.latitude, position.longitude);

    Placemark place = placemarks.first;

    String fullAddress =
        "${place.name},${place.thoroughfare}, ${place.subLocality}, ${place.locality}, "
        "${place.administrativeArea}, ${place.postalCode}";

    setState(() {
      addressController.text = fullAddress;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.lightblue,
        title: const Text("Add Address",style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600,)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: AppColors.whiteColor,),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              /// Confirm Action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightblue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Confirm Address",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white, //  text color
                  fontWeight: FontWeight.w600,
                ) ,
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Address Field + Location Icon
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
                alignment: Alignment.topLeft,
                child: Text("Address Type",style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),)),
            SizedBox(height: 4,),
            _textField("", landmarkController),

            Align(
              alignment: Alignment.topLeft,
                child
                : Text("House No",style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),)),
            SizedBox(height: 4,),
            Align(
                alignment: Alignment.topLeft,
                child: _textField("", houseController)),
            SizedBox(height: 4,),
            Align(
               alignment: Alignment.topLeft,
                child: Text("Building Bloc",style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),)),
            SizedBox(height: 4,),
            _textField("", buildingController),
            Align(
              alignment: Alignment.topLeft,
                child: Text("Landmark",style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500
                ),)),
            SizedBox(height: 4,),
            _textField("", landmarkController),
          ],
        ),
      ),
    );
  }
}