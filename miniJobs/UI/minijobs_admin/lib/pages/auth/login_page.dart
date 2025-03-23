import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/auth_code_request.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../../services/notification.service.dart';
import '../main/screens/main/main_screen.dart';
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
  bool _obscureText = true; // Added to toggle password visibility

  @override
  void initState() {
    super.initState();
  }

  void authenticateUserOnInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authenticationProvider = context.read<AuthenticationProvider>();
    });
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/logo.png",
                              height: screenHeight * 0.2,
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
                            FormBuilderTextField(
                              style: const TextStyle(color: Colors.black),
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
                                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              name: 'password',
                              style: const TextStyle(color: Colors.black),
                              obscureText: _obscureText,
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
                                prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
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

                                  if (result!=null && result!=false && mounted) {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => const MainScreen()),
                                    );
                                  } else if (mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content: Text(
                                          'Nevalidan email ili lozinka.'),
                                    ));
                                    _formKey.currentState?.reset();
                                  }
                                }
                              },
                              child: const Text(
                                'Prijavi se',
                              ),
                            ),
                            const SizedBox(height: 15),
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