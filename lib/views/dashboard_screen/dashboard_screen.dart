import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:medryder/config/colors/app_colors.dart';


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

  /// ================= INIT =================
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleLocationFlow();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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

                      _menuItem(Icons.person, "Profile"),
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
          _subMenu("Hospital Medicine Bookings"),
          _subMenu("Hospital Admission Bookings"),
          _subMenu("Hospital Doctor Bookings"),
          _subMenu("Hospital Diagnostic Bookings"),
          _subMenu("Hospital Ambulance Bookings"),
        ],
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

                /// -------- ROW 1 ----------
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white),
                    const SizedBox(width: 6),

                    /// ADDRESS
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          address ?? "Select Location",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ),

                    /// CREDIT CARD ICON
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.credit_card,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// NOTIFICATION ICON
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                /// -------- ROW 2 ----------
                Row(
                  children: [

                    /// SIDE NAV ICON
                    GestureDetector(
                      onTap: _openSideMenuDialog,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.menu),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// SEARCH BAR
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(12),
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

          /// BODY
          const Expanded(
            child: Center(
              child: Text("Dashboard Content"),
            ),
          ),
        ],
      ),

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.whiteColor,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        /// ✅ Selected color
        selectedItemColor: AppColors.lightblue,

        /// ✅ Unselected color
        unselectedItemColor: Colors.grey,

        /// ✅ Reduce font size
        selectedFontSize: 11,
        unselectedFontSize: 10,

        /// ✅ Icon animation duration./
        enableFeedback: true,

        /// ✅ Label visibility
        showUnselectedLabels: true,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_hospital_rounded),
            activeIcon: Icon(Icons.local_hospital_rounded, size: 30),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.health_and_safety),
            activeIcon: Icon(Icons.health_and_safety, size: 30),
            label: "Hospitals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_pharmacy),
            activeIcon: Icon(Icons.local_pharmacy, size: 30),
            label: "Medicines",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.science),
            activeIcon: Icon(Icons.science, size: 30),
            label: "Lab Tests",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            activeIcon: Icon(Icons.add_location, size: 30),
            label: "Diagnostics",
          ),
        ],
      ),
    );
  }
}