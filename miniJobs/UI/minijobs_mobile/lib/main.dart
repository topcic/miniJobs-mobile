import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/pages/auth/login_sign_up_page.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:minijobs_mobile/providers/authentication_provider.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/employer_provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/providers/job_type_provider.dart';
import 'package:minijobs_mobile/providers/proposed_answer_provider.dart';
import 'package:minijobs_mobile/providers/user_registration_provider.dart';
import 'package:minijobs_mobile/providers/user_provider.dart';
import 'package:minijobs_mobile/widgets/navbar.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (s) => UserProvider()),
      ChangeNotifierProvider(create: (s) => CityProvider()),
      ChangeNotifierProvider(create: (s) => UserRegistrationProvider()),
     // ChangeNotifierProvider(create: (s) => EmployerProvider()),
      ChangeNotifierProvider(create: (s) => JobTypeProvider()),
      ChangeNotifierProvider(create: (s) => ProposedAnswerProvider()),
      ChangeNotifierProvider(create: (s) => JobProvider()),
      ChangeNotifierProvider(create: (s) => ApplicantProvider()),
      ChangeNotifierProvider(create: (s) => EmployerProvider())

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const MyMaterialApp(),
    );
  }
}

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget {
  String title;
  MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in

    bool isLoggedIn = GetStorage().read('accessToken') != "";

    return MaterialApp(
      title: "My app",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: isLoggedIn ? const Navbar() : const LoginSignupPage(),
    );
  }
}

