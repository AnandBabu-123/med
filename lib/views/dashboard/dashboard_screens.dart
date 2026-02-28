import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../bloc/banner_bloc/banner_bloc.dart';
import '../../bloc/get_address_bloc/get_address_bloc.dart';
import '../../bloc/get_address_bloc/get_address_event.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/banner_repository/banner_repository.dart';
import '../../repository/get_address_repository/get_address_repository.dart';
import 'dashboard_widgets/address_bottom_sheet.dart';
import 'dashboard_widgets/dashboard_bottom_nav.dart';
import 'dashboard_widgets/dashboard_categories.dart';
import 'dashboard_widgets/dashboard_header.dart';
import 'dashboard_widgets/side_menu_dialog.dart';
import 'location_service/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
      builder: (_) {
        return BlocProvider(
          create: (_) => GetAddressBloc(
            GetAddressRepository(DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
            )),
          )..add(FetchAddressEvent()), // ✅ API CALL HERE
          child: AddressBottomSheet(
            onSelect: (selectedAddress) {
              setState(() {
                address = selectedAddress;
              });
            },
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

          /// ✅ PROVIDE BLOC HERE (CORRECT PLACE)
          Expanded(
            child: BlocProvider(
              create: (_) =>
                  BannerBloc(BannerRepository()),
              child: const DashboardCategories(),
            ),
          ),
        ],
      ),

      bottomNavigationBar: DashboardBottomNav(
        currentIndex: currentIndex,
        onChanged: (i) {
          setState(() => currentIndex = i);
        },
      ),
    );
  }
}