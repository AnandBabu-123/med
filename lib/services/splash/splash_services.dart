import 'dart:async';
import 'package:flutter/material.dart';

import '../../config/routes/routes_name.dart'; // Use material.dart for Navigator

class SplashServices {
  void isLogin(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
          () => Navigator.of(context).pushNamedAndRemoveUntil(
        RoutesName.loginScreen,
            (route) => false,
      ),
    );
  }
}
