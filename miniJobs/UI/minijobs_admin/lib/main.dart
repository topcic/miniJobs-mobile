import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_admin/pages/company_employer_signup.page.dart';
import 'package:minijobs_admin/pages/job_step2.dart';
import 'package:minijobs_admin/pages/job_step3.dart';
import 'package:minijobs_admin/pages/login_sign_up_page.dart';
import 'package:minijobs_admin/pages/verification_page.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:minijobs_admin/providers/city_provider.dart';
import 'package:minijobs_admin/providers/employer_provider.dart';
import 'package:minijobs_admin/providers/job_type_provider.dart';
import 'package:minijobs_admin/providers/proposed_answer_provider.dart';
import 'package:minijobs_admin/providers/user_registration_provider.dart';
import 'package:minijobs_admin/providers/user_provider.dart';
import 'package:minijobs_admin/widgets/navbar.dart';
import 'package:provider/provider.dart';

void main() async {
  await GetStorage.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (s) => UserProvider()),
      ChangeNotifierProvider(create: (s) => CityProvider()),
      ChangeNotifierProvider(create: (s) => UserRegistrationProvider()),
      ChangeNotifierProvider(create: (s) => EmployerProvider()),
      ChangeNotifierProvider(create: (s) => JobTypeProvider()),
      ChangeNotifierProvider(create: (s) => ProposedAnswerProvider()),

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
      home: MyMaterialApp(),
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
  const MyMaterialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My app",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        //  brightness: Brightness.light,
        ),
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: JobStep2Page(),
    );
  }
}

