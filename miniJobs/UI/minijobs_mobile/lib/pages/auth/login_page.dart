import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/auth_code_request.dart';
import 'package:minijobs_mobile/providers/authentication_provider.dart';
import 'package:minijobs_mobile/widgets/navbar.dart';
import 'package:provider/provider.dart';

import '../../helpers/auth_helper.dart';
import '../../services/notification.service.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final notificationService = NotificationService();
  late AuthenticationProvider _authenticationProvider;

 @override
  void initState() {
    super.initState();
    authenticateUserOnInit();
    AuthHelper.checkIsAuthenticated(context);
 }

  // Run authentication process on init
  void authenticateUserOnInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure provider is available after initial build
      _authenticationProvider = context.read<AuthenticationProvider>();
      //authenticateUser();
    });
  }

  // Method to authenticate user
  Future<void> authenticateUser() async {
    var autCodeRequest = AuthCodeRequest(
      "27topcic.mahir@gmail.com",
      "Arni1234",
      "password",
      "",
      "",
    );

    var result = await _authenticationProvider.tokens(autCodeRequest);

    if (!mounted) return; // Ensure the widget is still in the widget tree

    if (result) {
      // Navigate to Navbar if authentication is successful
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Navbar(),
      ));
    } else {
      notificationService.error("Nevalidna lozinka ili email");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider = context.read<AuthenticationProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo inside the card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              height: screenHeight * 0.2, // 20% of screen height
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Email Input
                            FormBuilderTextField(
                              name: 'email',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Email je obavezno polje";
                                } else if (!RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                    .hasMatch(value)) {
                                  return "Nevalidan format";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                prefixIcon:
                                const Icon(Icons.email, color: Colors.blue),
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Password Input
                            FormBuilderTextField(
                              name: 'password',
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Lozinka je obavezno polje";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Lozinka',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                prefixIcon:
                                const Icon(Icons.lock, color: Colors.blue),
                              ),
                            ),
                            const SizedBox(height: 30),
                            // Log in Button
                            ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState?.save();
                                if (_formKey.currentState!.validate()) {
                                  final Map<String, dynamic> formValues =
                                      _formKey.currentState!.value;
                                  final String email =
                                      formValues['email'] ?? '';
                                  final String password =
                                      formValues['password'] ?? '';
                                  var authCodeRequest = AuthCodeRequest(
                                    email,
                                    password,
                                    "password",
                                    "",
                                    "",
                                  );

                                  var result = await _authenticationProvider
                                      .tokens(authCodeRequest);

                                  if (result && mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => const Navbar()),
                                    );
                                  } else if (mounted) {
                                    notificationService.error('Nevalidan email ili lozinka');
                                    _formKey.currentState?.reset();
                                  }
                                }
                              },
                              child: const Text(
                                'Prijavi se',
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Forgot Password
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Zaboravili ste lozinku?",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}