import 'package:flutter/material.dart';

import '../../../config/routes/routes_name.dart';

import 'package:flutter/material.dart';

class DashboardMenuDialog {

  /// OPEN DIALOG
  static void open(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => const _DashboardMenuContent(),
    );
  }
}

class _DashboardMenuContent extends StatelessWidget {
  const _DashboardMenuContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// ========= HEADER =========
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [

                  Image.asset(
                    "assets/logo.png",
                    width: 130,
                  ),

                  const Spacer(),

                  /// LANGUAGE
                  _circleIcon(Icons.language),

                  const SizedBox(width: 10),

                  /// CLOSE
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: _circleIcon(Icons.close),
                  ),
                ],
              ),
            ),

            /// ========= MENU LIST =========
            Container(
              height: 550,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    _menuItemProfile(context, Icons.person, "Profile"),

                    _menuItemHospitals(
                        context,
                        Icons.local_hospital_rounded,
                        "Hospital Bookings"),

                    _menuItem(context, Icons.tablet,
                        "Wellness & Medicine Bookings"),

                    _menuItem(context, Icons.local_hospital,
                        "Online Doctor Booking"),

                    _menuItemLabBookings(
                        context, Icons.science, "Lab Bookings History"),

                    _menuItem(context, Icons.monitor_heart,
                        "Diagnostic Bookings"),

                    _menuItem(context, Icons.lock, "Med Locker"),

                    _menuItem(context, Icons.receipt_long,
                        "Med Rayder Subscription"),

                    _menuItem(context, Icons.credit_card, "E Card"),

                    _menuItem(context, Icons.note, "Acko Insurance"),

                    _menuItem(context, Icons.location_on, "Your Address"),

                    _menuItem(context, Icons.share, "Share App"),

                    _menuItem(context, Icons.person, "Contact Us"),

                    _menuItem(context, Icons.info, "About Us"),

                    _menuItem(context, Icons.logout, "Logout"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= COMMON ICON =================
  static Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.blue, size: 20),
    );
  }

  /// ================= MENU ITEMS =================
  static Widget _menuItem(
      BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title,
          style:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: () => Navigator.pop(context),
    );
  }

  static Widget _menuItemProfile(
      BuildContext context, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title,
          style:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pushNamed(context, RoutesName.profileScreen);
      },
    );
  }

  /// ================= HOSPITAL BOOKINGS =================
  static Widget _menuItemHospitals(
      BuildContext context, IconData icon, String title) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title,
          style:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      children: [
        _subMenuRoute(context, "Hospital Medicine Bookings",
            RoutesName.hospitalMedicineBooking),

        _subMenuRoute(context, "Hospital Admission Bookings",
            RoutesName.hospitalAdmissionBookings),

        _subMenuRoute(context, "Hospital Doctor Bookings",
            RoutesName.hospitalDoctorBookings),

        _subMenuRoute(context, "Hospital Diagnostic Bookings",
            RoutesName.hospitalDiagnosticBookings),

        _subMenuRoute(context, "Hospital Ambulance Bookings",
            RoutesName.hospitalAmbulanceBookings),
      ],
    );
  }

  /// ================= LAB BOOKINGS =================
  static Widget _menuItemLabBookings(
      BuildContext context, IconData icon, String title) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title,
          style:
          const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      children: [
        _subMenu(context, "MedRayder Labs History"),
        _subMenu(context, "Lab Tests Bookings"),
      ],
    );
  }

  /// ================= SUB MENU =================
  static Widget _subMenu(BuildContext context, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40),
      title: Text(title),
      onTap: () => Navigator.pop(context),
    );
  }

  static Widget _subMenuRoute(
      BuildContext context, String title, String route) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40),
      title: Text(title),
      onTap: () => Navigator.pushNamed(context, route),
    );
  }
}