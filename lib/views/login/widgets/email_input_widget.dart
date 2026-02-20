import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/login_bloc/login_bloc.dart';
import '../../../utils/validations.dart';


class EmailInputWidget extends StatelessWidget {
  final FocusNode emailFocusNode;

  const EmailInputWidget({super.key, required this.emailFocusNode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginStates>(
      buildWhen: (prev, curr) => prev.email != curr.email,
      builder: (context, state) {
        return TextFormField(
          keyboardType: TextInputType.emailAddress,
          focusNode: emailFocusNode,
          decoration: const InputDecoration(
            hintText: "Email",
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            context.read<LoginBloc>().add(EmailChange(email: value));
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email required';
            }
            if (!Validations.validateEmail(value)) {
              return 'Enter correct email';
            }
            return null;
          },
        );
      },
    );
  }
}

