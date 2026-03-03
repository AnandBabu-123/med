import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/language_bloc/language_bloc.dart';
import '../../../bloc/language_bloc/language_state.dart';
import '../../../config/language/app_strings.dart';

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
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {

        final language = state.language;

        final home = AppStrings.get(language, "home");
        final hospitals = AppStrings.get(language, "hospitals");
        final medicines = AppStrings.get(language, "medicines");
        final labTests = AppStrings.get(language, "labTests");
        final diagnostics = AppStrings.get(language, "diagnostics");

        return BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onChanged,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          showUnselectedLabels: true,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_hospital_rounded),
              label: home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.health_and_safety),
              label: hospitals,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.local_pharmacy),
              label: medicines,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.science),
              label: labTests,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_location),
              label: diagnostics,
            ),
          ],
        );
      },
    );
  }
}