import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/language_bloc/language_bloc.dart';
import '../../../bloc/language_bloc/language_state.dart';
import '../../../config/language/app_strings.dart';
import '../../../config/routes/routes_name.dart';
import '../../../network/api_constants.dart';

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

    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, langState) {

        final language = langState.language;

        String tr(String key) => AppStrings.get(language, key);

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 18),
                  child: Row(
                    children: [

                      Image.asset(
                        "assets/logo.png",
                        width: 130,
                      ),

                      const Spacer(),

                      /// LANGUAGE
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushNamed(
                            context,
                            RoutesName.languageScreen,
                            arguments: {
                              "from": LanguageSource.dashboard,
                            },
                          );
                        },
                        child: _circleIcon(Icons.language),
                      ),

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

                        _menuItemProfile(
                            context,
                            Icons.person,
                            tr("profile")),

                        _menuItemHospitals(
                            context,
                            Icons.local_hospital_rounded,
                            tr("hospitalBookings"),
                            tr),

                        _menuItem(
                            context,
                            Icons.tablet,
                            tr("wellnessMedicineBookings")),

                        _menuItem(
                            context,
                            Icons.local_hospital,
                            tr("onlineDoctorBooking")),

                        _menuItemLabBookings(
                            context,
                            Icons.science,
                            tr("labBookingsHistory"),
                            tr),

                        _menuItem(
                            context,
                            Icons.monitor_heart,
                            tr("diagnosticBookings")),

                        _menuItem(
                            context,
                            Icons.lock,
                            tr("medLocker")),

                        _menuItem(
                            context,
                            Icons.receipt_long,
                            tr("medRayderSubscription")),

                        _menuItem(
                            context,
                            Icons.credit_card,
                            tr("eCard")),

                        _menuItem(
                            context,
                            Icons.note,
                            tr("ackoInsurance")),

                        _menuItem(
                            context,
                            Icons.location_on,
                            tr("yourAddress")),

                        _menuItem(
                            context,
                            Icons.share,
                            tr("shareApp")),

                        _menuItem(
                            context,
                            Icons.person,
                            tr("contactUs")),

                        _menuItem(
                            context,
                            Icons.info,
                            tr("aboutUs")),

                        _menuItem(
                            context,
                            Icons.logout,
                            tr("logout")),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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

  /// ================= NORMAL MENU =================
  static Widget _menuItem(
      BuildContext context,
      IconData icon,
      String title) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  /// ================= PROFILE =================
  static Widget _menuItemProfile(
      BuildContext context,
      IconData icon,
      String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pushNamed(
            context,
            RoutesName.profileScreen);
      },
    );
  }

  /// ================= HOSPITAL BOOKINGS =================
  static Widget _menuItemHospitals(
      BuildContext context,
      IconData icon,
      String title,
      String Function(String) tr) {

    return ExpansionTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
      children: [

        _subMenuRoute(
            context,
            tr("hospitalMedicineBookings"),
            RoutesName.hospitalMedicineBooking),

        _subMenuRoute(
            context,
            tr("hospitalAdmissionBookings"),
            RoutesName.hospitalAdmissionBookings),

        _subMenuRoute(
            context,
            tr("hospitalDoctorBookings"),
            RoutesName.hospitalDoctorBookings),

        _subMenuRoute(
            context,
            tr("hospitalDiagnosticBookings"),
            RoutesName.hospitalDiagnosticBookings),

        _subMenuRoute(
            context,
            tr("hospitalAmbulanceBookings"),
            RoutesName.hospitalAmbulanceBookings),
      ],
    );
  }

  /// ================= LAB BOOKINGS =================
  static Widget _menuItemLabBookings(
      BuildContext context,
      IconData icon,
      String title,
      String Function(String) tr) {

    return ExpansionTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500),
      ),
      children: [
        _subMenu(context, tr("medrayderLabsHistory")),
        _subMenu(context, tr("labTestsBookings")),
      ],
    );
  }

  /// ================= SUB MENU =================
  static Widget _subMenu(
      BuildContext context,
      String title) {

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 DOT
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
          ),

          /// 🔹 TITLE
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.pop(context),
    );
  }

  static Widget _subMenuRoute(
      BuildContext context,
      String title,
      String route) {

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 40),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 DOT
          Container(
            margin: const EdgeInsets.only(top: 6, right: 8),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.circle,
            ),
          ),

          /// 🔹 TITLE
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
      onTap: () =>
          Navigator.pushNamed(context, route),
    );
  }
}