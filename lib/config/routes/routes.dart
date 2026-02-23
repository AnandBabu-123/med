import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/config/routes/routes_name.dart';
import 'package:medryder/views/hospital_bookings/hospital_admission_bookings/hospital_admission_bookings.dart';
import 'package:medryder/views/hospital_bookings/hospital_ambulance_bookings/hospital_ambulance_bookings.dart';
import 'package:medryder/views/hospital_bookings/hospital_diagnostic_bookings/hospital_diagnostic_bookings.dart';
import 'package:medryder/views/hospital_bookings/hospital_doctor_bookings/hospital_doctor_bookings.dart';
import 'package:medryder/views/hospital_bookings/hospital_medical_booking/hospital_medical_bookings.dart';
import 'package:medryder/views/profile/profile_screen.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/store_bloc/store_bloc.dart';
import '../../repository/store_repository/store_repository.dart';
import '../../views/home/home_screen.dart';
import '../../views/login/login_screen.dart';
import '../../views/onboarding/language_screen/language_screen.dart';
import '../../views/onboarding/onboarding_screen/onboarding_screen.dart';
import '../../views/onboarding/otp_screen/otp_screen.dart';
import '../../views/splash/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );

      case RoutesName.loginScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => LoginBloc(),
            child: const LoginScreen(),
          ),
        );

    // 🔥 FIX IS HERE
      case RoutesName.homeScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const HomeScreen(),
          ),
        );

      //// original screens

      case RoutesName.languageScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const LanguageScreen(),
          ),
        );

      case RoutesName.onBoardingScreen:
        final selectedLanguage = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: OnboardingScreen(
              selectedLanguage: selectedLanguage,
            ),
          ),
        );

      case RoutesName.otpScreen:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => OtpScreen(
            mobileNumber: args["mobile"],
            selectedLanguage: args["language"],
          ),
        );

      case RoutesName.profileScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const ProfileScreen(),
          ),
        );

      case RoutesName.hospitalMedicineBooking:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const HospitalMedicalBookings(),
          ),
        );

      case RoutesName.hospitalAdmissionBookings:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const HospitalAdmissionBookings(),
          ),
        );
      case RoutesName.hospitalDoctorBookings:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const HospitalDoctorBookings(),
          ),
        );

      case RoutesName.hospitalDiagnosticBookings:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const HospitalDiagnosticBookings(),
          ),
        );

      case RoutesName.hospitalAmbulanceBookings:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (_) => StoreBloc(StoreRepository()),
            child: const HospitalAmbulanceBookings(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) {
            return const Scaffold(
              body: Center(
                child: Text("No routes found"),
              ),
            );
          },
        );
    }
  }
}

