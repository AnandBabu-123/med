import 'package:flutter/material.dart';
import 'dart:async';
import '../../../bloc/otp_bloc/otp_bloc.dart';
import '../../../bloc/otp_bloc/otp_event.dart';
import '../../../bloc/otp_bloc/otp_state.dart';
import '../../../config/routes/routes_name.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';


class OtpScreen extends StatefulWidget {
  final String mobileNumber;
  final String selectedLanguage;
  final String apiOtp;

  const OtpScreen({
    super.key,
    required this.mobileNumber,
    required this.selectedLanguage,
    required this.apiOtp,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {

  /// OTP CONTROLLERS
  final List<TextEditingController> controllers =
  List.generate(4, (_) => TextEditingController());

  int seconds = 30;
  Timer? timer;

  /// ================= INIT =================
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  /// ================= TIMER =================
  void startTimer() {
    timer?.cancel();
    seconds = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds == 0) {
        t.cancel();
      } else {
        setState(() => seconds--);
      }
    });
  }

  /// ================= RESEND OTP API =================
  Future<void> resendOtp() async {
    try {
      final dio = Dio();

      final response = await dio.post(
        "https://medconnect.org.in/bharosa/app/ws/resend_otp",
        data: {
          "mobile": widget.mobileNumber,
        },
      );

      if (response.data["status"] == true) {

        _showSnack("OTP Resent Successfully");

        /// clear previous otp
        for (var c in controllers) {
          c.clear();
        }

        /// restart timer
        startTimer();

        /// focus first box
        FocusScope.of(context).requestFocus(FocusNode());

      } else {
        _showSnack(response.data["message"] ?? "Failed");
      }

    } catch (e) {
      _showSnack("Something went wrong");
    }
  }

  /// ================= DISPOSE =================
  @override
  void dispose() {
    timer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    super.dispose();
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
      ),

      /// ================= CONTINUE BUTTON =================
      bottomNavigationBar: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {

          if (state.status == OtpStatus.success) {
            Navigator.pushReplacementNamed(
              context,
              RoutesName.dashBoardScreens,
            );
          }

          if (state.status == OtpStatus.failure) {
            _showSnack(state.message);
          }
        },

        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            color: Colors.white,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.status == OtpStatus.loading
                    ? null
                    : () {

                  String enteredOtp =
                  controllers.map((e) => e.text).join();

                  if (enteredOtp.length < 4) {
                    _showSnack("Enter OTP");
                    return;
                  }

                  if (enteredOtp != widget.apiOtp) {
                    _showSnack("Invalid OTP");
                    return;
                  }

                  context.read<OtpBloc>().add(
                    VerifyOtpEvent(
                      mobile: widget.mobileNumber,
                      otp: enteredOtp,
                    ),
                  );
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                child: state.status == OtpStatus.loading
                    ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),

      /// ================= BODY =================
      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 40),

            Image.asset(
              "assets/logo.png",
              height: 150,
            ),

            const SizedBox(height: 30),

            Text(
              "Enter OTP sent to ${widget.mobileNumber}",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 25),

            /// OTP BOXES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) => _otpBox(i)),
            ),

            const SizedBox(height: 25),

            /// TIMER + RESEND
            Column(
              children: [

                Text(
                  "00:${seconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                GestureDetector(
                  onTap: seconds == 0 ? resendOtp : null,
                  child: Text(
                    "Resend OTP",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                      seconds == 0 ? Colors.blue : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ================= OTP BOX =================
  Widget _otpBox(int index) {
    return SizedBox(
      width: 55,
      child: TextField(
        controller: controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  /// ================= SNACKBAR =================
  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        content: Text(message),
      ),
    );
  }
}


// class OtpScreen extends StatefulWidget {
//   final String mobileNumber;
//   final String selectedLanguage;
//   final String apiOtp;
//
//   const OtpScreen({
//     super.key,
//     required this.mobileNumber,
//     required this.selectedLanguage,
//     required this.apiOtp,
//   });
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//
//   final List<TextEditingController> controllers =
//   List.generate(4, (_) => TextEditingController());
//
//   int seconds = 30;
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   void startTimer() {
//     timer?.cancel();
//     seconds = 30;
//
//     timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (seconds == 0) {
//         t.cancel();
//       } else {
//         setState(() => seconds--);
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     for (var c in controllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final continueText =
//     AppStrings.get(widget.selectedLanguage, "continue");
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(),
//         elevation: 0,
//       ),
//
//       /// ✅ LISTEN API RESULT
//       bottomNavigationBar: BlocConsumer<OtpBloc, OtpState>(
//         listener: (context, state) {
//
//           if (state.status == OtpStatus.success) {
//             // Navigate via route name instead of directly creating MaterialPageRoute
//             Navigator.pushReplacementNamed(
//               context,
//               RoutesName.dashBoardScreens,
//             );
//           }
//           if (state.status == OtpStatus.failure) {
//             _showSnack(context, state.message);
//           }
//         },
//
//         builder: (context, state) {
//
//           return Container(
//             padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
//             color: Colors.white,
//             child: SizedBox(
//               height: 50,
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: state.status == OtpStatus.loading
//                     ? null
//                     : () {
//
//                   /// ENTERED OTP
//                   String enteredOtp =
//                   controllers.map((e) => e.text).join();
//
//                   if (enteredOtp.length < 4) {
//                     _showSnack(context, "Enter OTP");
//                     return;
//                   }
//
//                   /// ✅ FRONTEND OTP MATCH
//                   if (enteredOtp != widget.apiOtp) {
//                     _showSnack(context, "Invalid OTP");
//                     return;
//                   }
//
//                   /// ✅ CALL VERIFY API
//                   context.read<OtpBloc>().add(
//                     VerifyOtpEvent(
//                       mobile: widget.mobileNumber,
//                       otp: enteredOtp,
//                     ),
//                   );
//                 },
//
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue, // ✅ BLUE BUTTON
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//
//                 child: state.status == OtpStatus.loading
//                     ? const SizedBox(
//                   height: 22,
//                   width: 22,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 2,
//                     color: Colors.white,
//                   ),
//                 )
//                     : const Text(
//                   "Continue",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//
//
//       body: SafeArea(
//         child: Column(
//           children: [
//
//             const SizedBox(height: 40),
//
//             Image.asset(
//               "assets/logo.png",
//               height: 150,
//             ),
//
//             const SizedBox(height: 30),
//
//             Text(
//               "Enter OTP sent to ${widget.mobileNumber}",
//               style: const TextStyle(
//                   fontWeight: FontWeight.w600),
//             ),
//
//             const SizedBox(height: 25),
//
//             Row(
//               mainAxisAlignment:
//               MainAxisAlignment.spaceEvenly,
//               children:
//               List.generate(4, (i) => _otpBox(i)),
//             ),
//
//             const SizedBox(height: 25),
//
//             Text("00:${seconds.toString().padLeft(2, '0')}"),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void _showSnack(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         behavior: SnackBarBehavior.floating,
//         backgroundColor: Colors.black87,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//         margin: const EdgeInsets.all(16),
//         content: Text(message),
//       ),
//     );
//   }
//
//   Widget _otpBox(int index) {
//     return SizedBox(
//       width: 55,
//       child: TextField(
//         controller: controllers[index],
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         maxLength: 1,
//         decoration: InputDecoration(
//           counterText: "",
//           border: OutlineInputBorder(
//             borderRadius:
//             BorderRadius.circular(10),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty && index < 3) {
//             FocusScope.of(context).nextFocus();
//           }
//         },
//       ),
//     );
//   }
// }
