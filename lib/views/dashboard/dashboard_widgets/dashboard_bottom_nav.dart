import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/colors/app_colors.dart';
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

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: 80,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
              )
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: onChanged,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: AppColors.lightblue,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 12,
            unselectedFontSize: 11,
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
          ),
        );
      },
    );
  }
}