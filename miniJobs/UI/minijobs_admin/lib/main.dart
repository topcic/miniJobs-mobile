import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_admin/pages/auth/login_page.dart';
import 'package:minijobs_admin/pages/main/constants.dart';
import 'package:minijobs_admin/providers/applicant_provider.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:minijobs_admin/providers/city_provider.dart';
import 'package:minijobs_admin/providers/country_provider.dart';
import 'package:minijobs_admin/providers/employer_provider.dart';
import 'package:minijobs_admin/providers/job_application_provider.dart';
import 'package:minijobs_admin/providers/job_provider.dart';
import 'package:minijobs_admin/providers/job_recommendation_provider.dart';
import 'package:minijobs_admin/providers/job_type_provider.dart';
import 'package:minijobs_admin/providers/proposed_answer_provider.dart';
import 'package:minijobs_admin/providers/rating_provider.dart';
import 'package:minijobs_admin/providers/recommendation_provider.dart';
import 'package:minijobs_admin/providers/report_provider.dart';
import 'package:minijobs_admin/providers/saved_job_provider.dart';
import 'package:minijobs_admin/providers/statistic_provider.dart';
import 'package:minijobs_admin/providers/user_registration_provider.dart';
import 'package:minijobs_admin/providers/user_provider.dart';
import 'package:minijobs_admin/services/notification.service.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/menu_app_controller.dart';
void main() async {
  await GetStorage.init();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (s) => UserProvider()),
      ChangeNotifierProvider(create: (s) => CityProvider()),
      ChangeNotifierProvider(create: (s) => UserRegistrationProvider()),
      ChangeNotifierProvider(create: (s) => JobTypeProvider()),
      ChangeNotifierProvider(create: (s) => ProposedAnswerProvider()),
      ChangeNotifierProvider(create: (s) => JobProvider()),
      ChangeNotifierProvider(create: (s) => ApplicantProvider()),
      ChangeNotifierProvider(create: (s) => EmployerProvider()),
      ChangeNotifierProvider(create: (s) => RatingProvider()),
      ChangeNotifierProvider(create: (s) => JobApplicationProvider()),
      ChangeNotifierProvider(create: (s) => JobRecommendationProvider()),
      ChangeNotifierProvider(create: (s) => RecommendationProvider()),
      ChangeNotifierProvider(create: (s) => MenuAppController()),
      ChangeNotifierProvider(create: (s) => StatisticProvider()),
      ChangeNotifierProvider(create: (s) => ReportProvider()),
      ChangeNotifierProvider(create: (s) => SavedJobProvider()),
      ChangeNotifierProvider(create: (s) => CountryProvider()),

    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NotificationService.navigatorKey,
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
    return MaterialApp(
      title: "Minijobs",
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: const LoginPage(),
    );
  }
}
