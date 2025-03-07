import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_admin/pages/auth/login_page.dart';
import 'package:minijobs_admin/pages/main/constants.dart';
import 'package:minijobs_admin/providers/applicant_provider.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:minijobs_admin/providers/base_provider.dart';
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
import 'package:minijobs_admin/services/config_service.dart';
import 'package:minijobs_admin/services/notification.service.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controllers/menu_app_controller.dart';
void main() async {
  await GetStorage.init();
  await ConfigService().init();
  await BaseProvider.initializeBaseUrl();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
      ChangeNotifierProvider(create: (_) => CityProvider()),
      ChangeNotifierProvider(create: (_) => UserRegistrationProvider()),
      ChangeNotifierProvider(create: (_) => JobTypeProvider()),
      ChangeNotifierProvider(create: (_) => ProposedAnswerProvider()),
      ChangeNotifierProvider(create: (_) => JobProvider()),
      ChangeNotifierProvider(create: (_) => ApplicantProvider()),
      ChangeNotifierProvider(create: (_) => EmployerProvider()),
      ChangeNotifierProvider(create: (_) => RatingProvider()),
      ChangeNotifierProvider(create: (_) => JobApplicationProvider()),
      ChangeNotifierProvider(create: (_) => JobRecommendationProvider()),
      ChangeNotifierProvider(create: (_) => RecommendationProvider()),
      ChangeNotifierProvider(create: (_) => MenuAppController()),
      ChangeNotifierProvider(create: (_) => StatisticProvider()),
      ChangeNotifierProvider(create: (_) => ReportProvider()),
      ChangeNotifierProvider(create: (_) => SavedJobProvider()),
      ChangeNotifierProvider(create: (_) => CountryProvider()),
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
