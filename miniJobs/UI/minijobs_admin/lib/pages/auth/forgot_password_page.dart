import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/user/user_change_password_request.dart';
import 'package:minijobs_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../services/notification.service.dart';
import 'login_page.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool showPasswordReset = false;
  final notificationService = NotificationService();
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
  }

  Future<void> sendEmail(String email) async {
    try {
      // Call the forgotPassword method
      bool? result = await _userProvider.forgotPassword(email);

      if (result == true) {
        // Show success notification if the API call is successful
        notificationService.success(
            'Molimo Vas provjerite Vaš email. Poslali smo Vam kod za promjenu lozinke.');
        setState(() {
          showPasswordReset = true; // Update UI if needed
        });
      }
    } catch (err) {

    }
  }
  Future<void> changePassword(String authCode,String newPassword) async {
    try {
      UserChangePasswordRequest request=UserChangePasswordRequest(authCode,newPassword);
      // Call the forgotPassword method
      bool? result = await _userProvider.changePassword(request);

      if (result == true) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false, // Removes all previous routes
        );
      }
    } catch (err) {

    }
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
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: screenHeight * 0.2, // 20% of screen height
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                // Title and description
                const Center(
                  child: Column(
                    children: [
                      Text(
                        "Zaboravljena lozinka",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Unesite Vaš email da biste promijenili lozinku",
                        style: TextStyle(
                            fontSize: 14, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Input
                      if (!showPasswordReset)
                        FormBuilderTextField(
                          name: 'email',
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: "Unesite email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            prefixIcon: const Icon(Icons.email, color: Colors.blue),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Email je obavezno polje";
                            }
                            if (!RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                .hasMatch(value)) {
                              return "Nevalidan format emaila";
                            }
                            return null;
                          },
                        ),
                      if (showPasswordReset)
                        Column(
                          children: [
                            FormBuilderTextField(
                              style: const TextStyle(color: Colors.black),
                              name: 'password',
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Lozinka",
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                errorMaxLines: 2,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Lozinka je obavezno polje";
                                }
                                if (value.length < 8 ||
                                    !value.contains(RegExp(r'[A-Z]')) ||
                                    !value.contains(RegExp(r'[a-z]')) ||
                                    !value.contains(RegExp(r'[0-9]'))) {
                                  return "Lozinka mora sadržavati najmanje 8 karaktera, velika i mala slova i brojeve";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              style: const TextStyle(color: Colors.black),
                              name: 'repeatPassword',
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Ponovljena lozinka",
                                prefixIcon:
                                const Icon(Icons.lock_outline),
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                ),
                              ),
                              validator: (value) {
                                final password = _formKey.currentState
                                    ?.fields['password']?.value;
                                if (value == null || value.isEmpty) {
                                  return "Ponovljena lozinka je obavezno polje";
                                }
                                if (value != password) {
                                  return "Lozinke nisu iste";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            FormBuilderTextField(
                              style: const TextStyle(color: Colors.black),
                              name: 'kod',
                              decoration: InputDecoration(
                                labelText: "Kod",
                                border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.circular(8.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Kod je obavezno polje";
                                }
                                if (!RegExp(r'^\d{4}$')
                                    .hasMatch(value)) {
                                  return "Kod mora sadržavati tačno 4 cifre";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              if (showPasswordReset) {
                                setState(() {
                                  showPasswordReset = false;
                                });
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              "Odustani",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              _formKey.currentState?.save();
                              if (_formKey.currentState!.validate()) {
                                if (!showPasswordReset) {
                                  final email = _formKey.currentState
                                      ?.fields['email']?.value;
                                  sendEmail(email);
                                } else {
                                  final password =
                                      _formKey.currentState
                                          ?.fields['password']?.value;
                                  final kod = _formKey.currentState
                                      ?.fields['kod']?.value;
                                  changePassword(kod, password);
                                }
                              }
                            },
                            child: Text(
                                showPasswordReset ? "Pošalji" : "Nastavi"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    ),
    ),
      )
    );
  }

}
