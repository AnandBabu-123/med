import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../../bloc/login_bloc/login_bloc.dart';
import '../../../config/routes/routes_name.dart';
import '../../../utils/enums.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formkey;

  const LoginButton({super.key, required this.formkey});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginStates>(
        listener: (context, state) {
          print("STATUS: ${state.postApiStatus}");
          print("MESSAGE: ${state.message}");

          if (state.postApiStatus == PostApiStatus.failure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }

          if (state.postApiStatus == PostApiStatus.success) {
            print("NAVIGATING TO HOME"); // 👈 CHECK THIS
            Navigator.pushReplacementNamed(
              context,
              RoutesName.homeScreen,
            // 👈 PASS USER ID
            );
          }
        },

        builder: (context, state) {
        if (state.postApiStatus == PostApiStatus.loading) {
          return const CircularProgressIndicator();
        }

        return ElevatedButton(
          onPressed: () {
            if (formkey.currentState!.validate()) {
              context.read<LoginBloc>().add(LoginApi());
            }
          },
          child: const Text("Login"),
        );
      },
    );
  }
}

