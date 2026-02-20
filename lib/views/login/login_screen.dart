import 'package:flutter/material.dart';
import 'package:medryder/views/login/widgets/email_input_widget.dart';
import 'package:medryder/views/login/widgets/login_button.dart';
import 'package:medryder/views/login/widgets/password_input_widget.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              EmailInputWidget(emailFocusNode: emailFocusNode),
              const SizedBox(height: 15),
              PasswordInputWidget(passwordFocusNode: passwordFocusNode),
              const SizedBox(height: 10),
              LoginButton(formkey: _formKey),
            ],
          ),
        ),
      ),
    );
  }
}

