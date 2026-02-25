import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class DashboardBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onChanged;

  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onChanged,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 11,
      unselectedFontSize: 10,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.local_hospital_rounded),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.health_and_safety),
          label: "Hospitals",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_pharmacy),
          label: "Medicines",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.science),
          label: "Lab Tests",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_location),
          label: "Diagnostics",
        ),
      ],
    );
  }
}