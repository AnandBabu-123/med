import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/login_bloc/login_bloc.dart';

class PasswordInputWidget extends StatelessWidget {
  final FocusNode passwordFocusNode;

  const PasswordInputWidget({super.key, required this.passwordFocusNode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginStates>(
      buildWhen: (prev, curr) => prev.password != curr.password,
      builder: (context, state) {
        return TextFormField(
          obscureText: true,
          focusNode: passwordFocusNode,
          decoration: const InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<LoginBloc>().add(PasswordChange(password: value));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password required';
            }
            if (value.length < 6) {
              return 'Min 6 characters';
            }
            return null;
          },
        );
      },
    );
  }
}

