import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/language_bloc/langauge_bloc.dart';
import 'bloc/language_bloc/language_event.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

/// OPTIONAL SSL BYPASS (if you already use)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        ///  GLOBAL LANGUAGE BLOC
        BlocProvider<LanguageBloc>(
          create: (_) => LanguageBloc()..add(LoadLanguage()),
        ),

      ],
      child: MaterialApp(
        title: 'Med Rayder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
          ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: RoutesName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}