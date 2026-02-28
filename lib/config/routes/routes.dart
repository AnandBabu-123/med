import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/post_address_bloc/post_address_bloc.dart';
import 'package:medryder/config/routes/routes_name.dart';
import 'package:medryder/views/address/add_address.dart';
import 'package:medryder/views/hospital_bookings/hospital_admission_bookings/hospital_admission_bookings.dart';
import 'package:medryder/views/hospital_bookings/hospital_diagnostic_bookings/hospital_diagnostic_bookings.dart';
import 'package:medryder/views/hospital_bookings/hospital_doctor_bookings/hospital_doctor_bookings.dart';
import 'package:medryder/views/hospital_bookings/hospital_medical_booking/hospital_medical_bookings.dart';
import 'package:medryder/views/profile/profile_screen.dart';
import '../../bloc/otp_bloc/otp_bloc.dart';
import '../../bloc/pharmacy_bloc/pharmacy_bloc.dart';
import '../../bloc/pharmacy_bloc/pharmcy_event.dart';
import '../../bloc/profile_bloc/profile_bloc.dart';
import '../../bloc/signup_bloc/signup_bloc.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/otp_respository/otp_repository.dart';
import '../../repository/pharmacy_repository/pharmacy_repository.dart';
import '../../repository/post_address_repository/post_address_repository.dart';
import '../../repository/prifile_repository/profile_repository.dart';
import '../../repository/signup_repository/signup_repository.dart';
import '../../views/dashboard/dashboard_screens.dart';
import '../../views/onboarding/language_screen/language_screen.dart';
import '../../views/onboarding/onboarding_screen/onboarding_screen.dart';
import '../../views/onboarding/otp_screen/otp_screen.dart';
import '../../views/onboarding/signup_screen/signup_screen.dart';
import '../../views/pharmacy/pharmacy_screen.dart';
import '../../views/splash/splash_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );


      case RoutesName.dashBoardScreens:
        return MaterialPageRoute(
          builder: (context) => const DashboardScreens(),
        );



    //// original screens

      case RoutesName.languageScreen:
        return MaterialPageRoute(
          builder: (context) => const LanguageScreen(),
        );


      case RoutesName.onBoardingScreen:
        final selectedLanguage = settings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => const OnboardingScreen(selectedLanguage: ''),
        );


      case RoutesName.otpScreen:
        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OtpBloc(OtpRepository(DioClient(
              dio: Dio(),
              networkInfo: NetworkInfo(),
            ),)),
            child: OtpScreen(
              mobileNumber: args["mobile"],
              selectedLanguage: args["language"],
              apiOtp: args["otp"], // ✅ REQUIRED
            ),
          ),
        );

      case RoutesName.signupScreen:
        final language = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SignupBloc(SignupRepository()),
            child: SignupScreen(
              selectedLanguage: language,
            ),
          ),
        );
      case RoutesName.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(ProfileRepository()),
            child: const ProfileScreen(),
          ),
        );

      case RoutesName.hospitalMedicineBooking:
        return MaterialPageRoute(
          builder: (context) => const HospitalMedicalBookings(),
        );


      case RoutesName.hospitalAdmissionBookings:
        return MaterialPageRoute(
          builder: (context) => const HospitalAdmissionBookings(),
        );

      case RoutesName.hospitalDoctorBookings:
        return MaterialPageRoute(
          builder: (context) => const HospitalDoctorBookings(),
        );

      case RoutesName.hospitalDiagnosticBookings:
        return MaterialPageRoute(
          builder: (context) => const HospitalDiagnosticBookings(),
        );

      case RoutesName.hospitalAmbulanceBookings:
        return MaterialPageRoute(
          builder: (context) => const HospitalAdmissionBookings(),
        );


      case RoutesName.addAddress:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
                PostAddressBloc(PostAddressRepository(DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ))),
            child: const AddAddress(),
          ),
        );
      case RoutesName.pharmacyScreen:
        final language = settings.arguments as String;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) =>
            PharmacyBloc(PharmacyRepository())
              ..add(FetchPharmacyCategories(language)),
            child: PharmacyScreen(
              selectedLanguage: language,
            ),
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

