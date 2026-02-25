import 'package:flutter/material.dart';
import '../../config/colors/app_colors.dart';
import '../../config/routes/routes_name.dart';
import 'dashboard_widgets/dashboard_bottom_nav.dart';
import 'dashboard_widgets/dashboard_categories.dart';
import 'dashboard_widgets/dashboard_header.dart';
import 'dashboard_widgets/side_menu_dialog.dart';
import 'location_service/location_service.dart';



class DashboardScreens extends StatefulWidget {
  const DashboardScreens({super.key});

  @override
  State<DashboardScreens> createState() => _DashboardScreensState();
}

class _DashboardScreensState extends State<DashboardScreens>
    with WidgetsBindingObserver {

  int currentIndex = 0;
  String? address;

  final ScrollController _scrollController = ScrollController();
  double _scrollPos = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _fetchLocation();
    _autoScroll();
  }

  /// ================= LOCATION =================
  Future<void> _fetchLocation() async {
    final result = await LocationService.getExactAddress();
    if (result != null) {
      setState(() => address = result);
    }
  }

  /// ================= AUTO SCROLL =================
  void _autoScroll() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 60));

      if (!_scrollController.hasClients) return true;

      final max = _scrollController.position.maxScrollExtent;

      if (max <= 0) return true;

      _scrollPos += 1;
      if (_scrollPos >= max) _scrollPos = 0;

      _scrollController.jumpTo(_scrollPos);
      return true;
    });
  }

  /// ================= LOCATION BOTTOM SHEET =================
  void _openLocationBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom:
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Addresses",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
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
                        style:
                        const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ADD NEW ADDRESS
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, RoutesName.addAddress);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.lightblue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add,
                      color: Colors.white),
                  label: const Text(
                    "Add New Address",
                    style:
                    TextStyle(color: Colors.white),
                  ),
                ),
              ),

            ],
          ),
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

          /// HEADER
          DashboardHeader(
            address: address,
            scrollController: _scrollController,
            onMenuTap: () {
              DashboardMenuDialog.open(context);
            },
            onLocationTap: _openLocationBottomSheet,
          ),

          /// BODY
          const Expanded(
            child: DashboardCategories(),
          ),
        ],
      ),

      /// ✅ FIXED PARAMETER ERROR HERE
      bottomNavigationBar: DashboardBottomNav(
        currentIndex: currentIndex,
        onChanged: (i) {
          setState(() => currentIndex = i);
        },
      ),
    );
  }
}