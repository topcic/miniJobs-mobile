import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/pages/auth/login_sign_up_page.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:minijobs_mobile/providers/authentication_provider.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/employer_provider.dart';
import 'package:minijobs_mobile/providers/job_application_provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/providers/job_recommendation_provider.dart';
import 'package:minijobs_mobile/providers/job_type_provider.dart';
import 'package:minijobs_mobile/providers/proposed_answer_provider.dart';
import 'package:minijobs_mobile/providers/rating_provider.dart';
import 'package:minijobs_mobile/providers/recommendation_provider.dart';
import 'package:minijobs_mobile/providers/user_registration_provider.dart';
import 'package:minijobs_mobile/providers/user_provider.dart';
import 'package:minijobs_mobile/services/config_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await ConfigService().init();           // Initialize ConfigService
  await BaseProvider.initializeBaseUrl(); // Initialize BaseProvider base URL
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
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in (this would typically use AuthenticationProvider)
    bool isLoggedIn = false; // Replace with actual logic from AuthenticationProvider

    return MaterialApp(
      title: 'MiniJobs App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        quill.FlutterQuillLocalizations.delegate, // Add this for flutter_quill localization
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        // Add other supported locales (e.g., Locale('sr', '') for Serbian) as needed
      ],
      home: isLoggedIn ? const Placeholder() : const LoginSignupPage(), // Replace Placeholder with your logged-in home screen
    );
  }
}

class MyAppBar extends StatelessWidget {
  final String title;
  const MyAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}