import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medryder/config/colors/app_colors.dart';
import '../../config/routes/routes_name.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {

  int currentIndex = 0;
  String? address;
  bool isBottomSheetOpen = false;

  late ScrollController _locationScrollController;
  double _scrollPosition = 0;


  /// ================= INIT =================
  @override
  void initState() {
    super.initState();
    _locationScrollController = ScrollController();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLocationFlow();
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationScrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 60));

      if (!_locationScrollController.hasClients) return true;

      final maxScroll =
          _locationScrollController.position.maxScrollExtent;

      if (maxScroll <= 0) return true; // text small → no scroll

      _scrollPosition += 1;

      if (_scrollPosition >= maxScroll) {
        _scrollPosition = 0; // restart
      }

      _locationScrollController.jumpTo(_scrollPosition);

      return true;
    });
  }

  /// ================= APP RESUME =================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleLocationFlow();
    }
  }

  /// ================= LOCATION FLOW =================
  Future<void> _handleLocationFlow() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();

    if (enabled) {
      await _getExactLocation();
    } else {
      if (!isBottomSheetOpen) {
        _showLocationBottomSheet();
      }
    }
  }

  /// ================= GET ADDRESS =================
  Future<void> _getExactLocation() async {
    try {
      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark p = placemarks.first;

      List<String> parts = [
        if (p.name != null && p.name!.isNotEmpty) p.name!,
        if (p.thoroughfare != null) p.thoroughfare!,
        if (p.subLocality != null) p.subLocality!,
        if (p.locality != null) p.locality!,
        if (p.administrativeArea != null) p.administrativeArea!,
        if (p.postalCode != null) p.postalCode!,
      ];

      setState(() {
        address = parts.join(", ");
      });

      if (isBottomSheetOpen) {
        Navigator.pop(context);
        isBottomSheetOpen = false;
      }
    } catch (e) {
      debugPrint("Location error $e");
    }
  }

  /// ================= LOCATION SHEET =================
  void _showLocationBottomSheet() {
    isBottomSheetOpen = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: ListTile(
          leading: const Icon(Icons.my_location, color: AppColors.lightblue,),
          title: const Text("Use Current Location"),
          onTap: () async {
            bool enabled =
            await Geolocator.isLocationServiceEnabled();

            if (!enabled) {
              await Geolocator.openLocationSettings();
            } else {
              _getExactLocation();
            }
          },
        ),
      ),
    );
  }

  /// ================= SIDE MENU DIALOG =================
  /// ================= SIDE MENU DIALOG =================
  void _openSideMenuDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// ========= HEADER (BLUE) =========
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 18),

                child: Row(
                  children: [

                    Center(
                      child: Image.asset(
                        "assets/logo.png",

                        width: 130,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Spacer(),

                    /// LANGUAGE ICON (ROUND)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.language,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// CLOSE ICON (ROUND)
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.blue,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// ========= MENU LIST (WHITE + SCROLL) =========
              Container(
                color: Colors.white,
                height: 550, // dialog scroll height
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      _menuItemProfile(Icons.person, "Profile"),
                      _menuItemHospitals(Icons.local_hospital_rounded, "Hospital Bookings"),
                      _menuItem(Icons.tablet, "Wellness & Medicine Bookings"),
                      _menuItem(Icons.local_hospital, "Online Doctor Booking"),
                      _menuItemLabBookings(Icons.science, "Lab Bookings History"),
                      _menuItem(Icons.monitor_heart, "Diagnostic Bookings"),
                      _menuItem(Icons.lock, "Med Locker"),
                      _menuItem(Icons.receipt_long, "Med Rayder Subscription"),
                      _menuItem(Icons.credit_card, "E Card"),
                      _menuItem(Icons.note, "Acko Insurance"),
                      _menuItem(Icons.location_on, "Your Address"),
                      _menuItem(Icons.share, "Share App"),
                      _menuItem(Icons.person, "Contact Us"),
                      _menuItem(Icons.info, "About Us"),
                      _menuItem(Icons.logout, "Logout"),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItemLabBookings(IconData icon, String title) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // removes line
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black87),

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        // dropdown icon automatically appears at end
        trailing: const Icon(Icons.keyboard_arrow_down),

        children: [
          _subMenu("MedRayder Labs History"),
          _subMenu("Lab Tests Bookings"),


        ],
      ),
    );
  }

  Widget _menuItemHospitals(IconData icon, String title) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // removes line
      ),
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.black87),

        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),

        // dropdown icon automatically appears at end
        trailing: const Icon(Icons.keyboard_arrow_down),

        children: [
          _subMenuMedicalBookings("Hospital Medicine Bookings"),
          _subMenuAdmissionBookings("Hospital Admission Bookings"),
          _subMenuDoctorBookings("Hospital Doctor Bookings"),
          _subMenuDiagnosticBookings("Hospital Diagnostic Bookings"),
          _subMenuAmbulanceBookings("Hospital Ambulance Bookings"),
        ],
      ),
    );
  }
  Widget _subMenuMedicalBookings(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesName.hospitalMedicineBooking,

          );
        },
      ),
    );
  }
  Widget _subMenuAdmissionBookings(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesName.hospitalAdmissionBookings,

          );
        },
      ),
    );
  }
  Widget _subMenuDoctorBookings(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutesName.hospitalDoctorBookings,

          );
        },
      ),
    );
  }

  Widget _subMenuDiagnosticBookings(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        onTap: () {
        Navigator.pushNamed(context, RoutesName.hospitalDiagnosticBookings);
        },
      ),
    );
  }
  Widget _subMenuAmbulanceBookings(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        onTap: () {
        Navigator.pushNamed(context, RoutesName.hospitalAmbulanceBookings);
        },
      ),
    );
  }

  Widget _subMenu(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        onTap: () {
         Navigator.pop(context);
        },
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _menuItemProfile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesName.profileScreen,

        );
      },
    );
  }

  /// ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Column(
        children: [

          /// ================= BLUE HEADER =================
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              color: AppColors.lightblue,
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(22)),
            ),
            child: Column(
              children: [

                /// -------- ROW 1 (LOCATION) ----------
                Row(
                  children: [
                    GestureDetector(
                      onTap: _openLocationBottomSheet,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),

                    Expanded(
                      child: SingleChildScrollView(
                        controller: _locationScrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        child: Text(
                          address ?? "Select Location",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ),

                    _circleIcon(Icons.credit_card),
                    const SizedBox(width: 10),
                    _circleIcon(Icons.notifications),
                  ],
                ),

                const SizedBox(height: 15),

                /// -------- ROW 2 (MENU + SEARCH) ----------
                Row(
                  children: [
                    GestureDetector(
                      onTap: _openSideMenuDialog,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.menu),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Search medicines...",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: Icon(Icons.mic),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
             SizedBox(height: 15,),
          /// ================= WHITE DASHBOARD AREA =================
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [

                  ///  HORIZONTAL CATEGORY SCROLL
                  Container(
                    height: 115,
                    padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _svgCategory("assets/image_three.png", "Ambulance"),
                        _svgCategory("assets/image_six.png", "Admission"),
                        _svgCategory("assets/image_seven.png", "Treatment Planning"),
                        _svgCategory("assets/image_one.png", "Online Pharmacy"),
                        _svgCategory("assets/image_five.png", "Online Doctors"),
                        _svgCategory("assets/image_four.png", "Lab Tests Booking"),
                        _svgCategory("assets/image_five.png", "Diagnostics Center"),
                      ],
                    ),
                  ),

                  /// DASHBOARD CONTENT
                  const SizedBox(height: 30),
                  const Center(
                    child: Text(
                      "Dashboard Content",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),

                  const SizedBox(height: 400), // demo scroll space
                ],
              ),
            ),
          ),
        ],
      ),

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.whiteColor,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.lightblue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_rounded),
              activeIcon: Icon(Icons.local_hospital_rounded, size: 30),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety),
              activeIcon: Icon(Icons.health_and_safety, size: 30),
              label: "Hospitals"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_pharmacy),
              activeIcon: Icon(Icons.local_pharmacy, size: 30),
              label: "Medicines"),
          BottomNavigationBarItem(
              icon: Icon(Icons.science),
              activeIcon: Icon(Icons.science, size: 30),
              label: "Lab Tests"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_location),
              activeIcon: Icon(Icons.add_location, size: 30),
              label: "Diagnostics"),
        ],
      ),
    );
  }
  /// ================= LOCATION BOTTOM SHEET =================
  void _openLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Addresses",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),

              const SizedBox(height: 15),

              /// CURRENT ADDRESS
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade100,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Colors.blue),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        address ?? "No address selected",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              ///  ADD NEW ADDRESS BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                  Navigator.pushNamed(context, RoutesName.addAddress);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightblue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.black, size: 20),
    );
  }

  Widget _svgCategory(String asset, String title) {
    return Container(
      width: 77,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(child: _loadIcon(asset)),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
  Widget _loadIcon(String asset) {
    if (asset.toLowerCase().endsWith(".svg")) {
      return SvgPicture.asset(
        asset,
        height: 28,
        width: 28,
        fit: BoxFit.contain,
      );
    }
    return Image.asset(
      asset,
      height: 28,
      width: 28,
      fit: BoxFit.contain,
    );
  }

}