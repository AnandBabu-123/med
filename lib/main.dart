import 'dart:io';

import 'package:flutter/material.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';
import 'network/http_override.dart';

  void main() {
    HttpOverrides.global = MyHttpOverrides();
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Med Rayder',
        debugShowCheckedModeBanner: false,

        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
        ),

        initialRoute: RoutesName.languageScreen,
        onGenerateRoute: Routes.generateRoute,
      );
    }
  }


