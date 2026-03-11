import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medryder/bloc/diagnostic_test_event/diagnostic_tests_bloc.dart';
import 'package:medryder/bloc/lab_bloc/lab_bloc.dart';
import 'package:medryder/bloc/profile_bloc/profile_bloc.dart';
import 'package:medryder/config/routes/view.dart';
import 'package:medryder/repository/diagnostic_tests_repository/diagnostic_tests_repository.dart';
import 'package:medryder/repository/get_lab_test_repository/lab_repository.dart';
import 'package:medryder/repository/profile_repository/profile_repository.dart';
import '../../bloc/confirm_pharmacy_order_bloc/confirm_pharmacy_order_bloc.dart';
import '../../bloc/diagnostic_prescription_bloc/diagnostic_prescription_bloc.dart';
import '../../bloc/diagnostics_bloc/diagnostics_bloc.dart';
import '../../bloc/lab_test_bloc/lab_test_bloc.dart';
import '../../bloc/otp_bloc/otp_bloc.dart';
import '../../bloc/pharmacy_bloc/pharmacy_bloc.dart';
import '../../bloc/post_address_bloc/post_address_bloc.dart';
import '../../bloc/profile_bloc/profile_event.dart';
import '../../bloc/signup_bloc/signup_bloc.dart';
import '../../config/routes/routes_name.dart';
import '../../network/api_constants.dart';
import '../../network/dio_network/dio_client.dart';
import '../../network/dio_network/network_info.dart';
import '../../repository/diagnostic_repository/diagnostic_repository.dart';
import '../../repository/dignoastic_prescription_booking/diagnostic_prescription_repository.dart';
import '../../repository/get_lab_test_repository/lab_test_repository.dart';
import '../../repository/otp_repository/otp_repository.dart';
import '../../repository/pharmacy_repository/confirm_address_repository.dart';
import '../../repository/pharmacy_repository/pharmacy_repository.dart';
import '../../repository/post_address_repository/post_address_repository.dart';
import '../../repository/signup_repository/signup_repository.dart';
import '../../views/onboarding/language_screen/language_screen.dart';


class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {

    /// SPLASH
      case RoutesName.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

    /// DASHBOARD
      case RoutesName.dashBoardScreens:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreens(),
        );

    /// LANGUAGE
    //   case RoutesName.languageScreen:
    //     return MaterialPageRoute(
    //       builder: (_) => const LanguageScreen(),
    //     );


      case RoutesName.languageScreen:

        final args =
        settings.arguments as Map<String, dynamic>?;

        final from = args?["from"] ?? LanguageSource.splash;

        return MaterialPageRoute(
          builder: (_) => LanguageScreen(from: from),
        );
    /// ONBOARDING
      case RoutesName.onBoardingScreen:

        final language =
            settings.arguments as String? ?? "en";

        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(
            selectedLanguage: language,
          ),
        );

    /// OTP
      case RoutesName.otpScreen:

        final args =
        settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => OtpBloc(
              OtpRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: OtpScreen(
              mobileNumber: args?["mobile"] ?? "",
              selectedLanguage: args?["language"] ?? "en",
              apiOtp: args?["otp"] ?? "",
            ),
          ),
        );

    /// SIGNUP
      case RoutesName.signupScreen:

        final language =
            settings.arguments as String? ?? "en";

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => SignupBloc(SignupRepository()),
            child: SignupScreen(
              selectedLanguage: language,
            ),
          ),
        );

    /// PROFILE
      case RoutesName.profileScreen:

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ProfileBloc(
              ProfileRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            )..add(
              LoadProfileDropdowns(
                language: "en",
              ),
            ),
            child: const ProfileScreen(),
          ),
        );
    /// HOSPITAL BOOKINGS
      case RoutesName.hospitalMedicineBooking:
        return MaterialPageRoute(
          builder: (_) => const HospitalMedicalBookings(),
        );

      case RoutesName.hospitalAdmissionBookings:
        return MaterialPageRoute(
          builder: (_) => const HospitalAdmissionBookings(),
        );

      case RoutesName.hospitalDoctorBookings:
        return MaterialPageRoute(
          builder: (_) => const HospitalDoctorBookings(),
        );

      case RoutesName.hospitalDiagnosticBookings:
        return MaterialPageRoute(
          builder: (_) => const HospitalDiagnosticBookings(),
        );

    /// ADD ADDRESS
      case RoutesName.addAddress:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PostAddressBloc(
              PostAddressRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: const AddAddress(),
          ),
        );


      case RoutesName.pharmacyScreen:

        final args = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PharmacyBloc(
              PharmacyRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: PharmacyScreen(
              lat: args?["lat"] ?? "",
              lon: args?["lon"] ?? "",
              language: args?["language"] ?? "en",
            ),
          ),
        );

      case RoutesName.pharmacyDetailsScreen:

        final args = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => PharmacyDetailsScreen(
            pharmacyId: args?["pharmacyId"] ?? 0,
            language: args?["language"] ?? "en",
            location: args?["location"] ?? "",
          ),
        );



      case RoutesName.confirmPharmacyScreen:

        final args = settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ConfirmPharmacyOrderBloc(
              ConfirmAddressRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: ConfirmPharmacyOrderScreen(
              file: args?["file"],
              pharmacyId: args?["pharmacyId"] ?? 0,
              orderType: args?["orderType"] ?? "home_delivery",
              language: args?["language"] ?? "en",
              location: args?["location"] ?? "",
            ),
          ),
        );

    /// DIAGNOSTICS
      case RoutesName.diagnosticScreen:

        final args =
        settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DiagnosticsBloc(
              GetDiagnosticRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: DiagnosticsScreen(
              lat: args?["lat"] ?? "",
              lon: args?["lon"] ?? "",
              language: args?["language"] ?? "en",
            ),
          ),
        );

      case RoutesName.test_diagnostic:

        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DiagnosticTestsBloc(
              DiagnosticTestsRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: DiagnosticTestsScreen(
              diagnosticId: args["diagnostic_id"],
              language: args["language"],
            ),
          ),
        );

      case RoutesName.attachPrescriptionScreen:

        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DiagnosticPrescriptionBloc(
              DiagnosticPrescriptionRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: AttachPrescriptionScreen(
              diagnosticId: args["diagnostic_id"],
              language: args["language"],
              location: args["location"],


            ),
          ),
        );


      case RoutesName.labScreen:

        final args = settings.arguments as Map<String, dynamic>;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LabBloc(
              LabRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: LabTestScreen(
              labTestId: args["lab_test_id"],
              language: args["language"],
            ),
          ),
        );

    /// LAB TEST
      case RoutesName.labTestScreen:

        final args =
        settings.arguments as Map<String, dynamic>?;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LabTestBloc(
              LabTestRepository(
                DioClient(
                  dio: Dio(),
                  networkInfo: NetworkInfo(),
                ),
              ),
            ),
            child: GetLabTests(
              lat: args?["lat"] ?? "",
              lon: args?["lon"] ?? "",
              language: args?["language"] ?? "en",
            ),
          ),
        );

    /// DEFAULT
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No routes found")),
          ),
        );
    }
  }
}