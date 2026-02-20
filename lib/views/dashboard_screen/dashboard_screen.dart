import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {

  final GlobalKey<ScaffoldState> scaffoldKey =
  GlobalKey<ScaffoldState>();

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
    bool serviceEnabled =
    await Geolocator.isLocationServiceEnabled();

    if (serviceEnabled) {
      await _getExactLocation();
    } else {
      if (!isBottomSheetOpen) {
        _showLocationBottomSheet();
      }
    }
  }

  /// ================= GET EXACT LOCATION =================
  Future<void> _getExactLocation() async {
    try {
      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) return;

      /// ✅ FORCE GPS HIGH ACCURACY
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: 15),
      );

      /// ✅ REVERSE GEOCODING
      List<Placemark> placemarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      /// ✅ CLEAN HUMAN READABLE ADDRESS
      String fullAddress =
          "${place.name}, "
          "${place.street}, "
          "${place.locality}, "
          "${place.subAdministrativeArea}, "
          "${place.administrativeArea}, "
          "${place.postalCode}";

      setState(() {
        address = fullAddress;
      });

      /// close bottom sheet safely
      if (isBottomSheetOpen) {
        Navigator.of(context, rootNavigator: true).pop();
        isBottomSheetOpen = false;
      }
    } catch (e) {
      debugPrint("Location Error: $e");
    }
  }

  /// ================= LOCATION BOTTOM SHEET =================
  void _showLocationBottomSheet() {
    isBottomSheetOpen = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Select Location",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              /// CURRENT LOCATION
              ListTile(
                leading: const Icon(Icons.my_location,
                    color: Colors.blue),
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

              const Divider(),

              /// MANUAL ENTRY
              ListTile(
                leading: const Icon(Icons.edit_location_alt,
                    color: Colors.green),
                title: const Text("Enter Location Manually"),
                onTap: () {
                  Navigator.pop(context);
                  isBottomSheetOpen = false;
                  _manualAddressDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// ================= MANUAL ADDRESS =================
  void _manualAddressDialog() {
    TextEditingController controller =
    TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Address"),
        content: TextField(
          controller: controller,
          decoration:
          const InputDecoration(hintText: "Enter address"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                address = controller.text;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.location_on),
              const SizedBox(width: 6),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    address ?? "Select Location",
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: const [
          Icon(Icons.credit_card),
          SizedBox(width: 15),
          Icon(Icons.notifications),
          SizedBox(width: 12),
        ],
      ),

      body: Column(
        children: [
          /// SEARCH + MENU
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                InkWell(
                  onTap: () =>
                      scaffoldKey.currentState?.openDrawer(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search...",
                      prefixIcon:
                      const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Expanded(
            child: Center(
              child: Text("Dashboard Content"),
            ),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Categories"),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: "Address"),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Cart"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"),
        ],
      ),
    );
  }
}