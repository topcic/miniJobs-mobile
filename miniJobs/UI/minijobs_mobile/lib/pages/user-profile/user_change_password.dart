import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user/user_change_password_request.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/notification.service.dart';
import 'package:provider/provider.dart';

import '../auth/login_sign_up_page.dart';

class UserChangePassword extends StatefulWidget {
  const UserChangePassword({super.key});

  @override
  _UserChangePasswordState createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool showPasswordFields = false;
  final notificationService = NotificationService();
  late UserProvider _userProvider;
  late AuthenticationProvider _authenticationProvider;
  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _authenticationProvider = context.read<AuthenticationProvider>();

  }
  Future<void> sendEmail() async {
    try {
      // Call the forgotPassword method
      bool? result = await _userProvider.forgotPassword(GetStorage().read('emailaddress') ?? '');

      if (result == true) {
        // Show success notification if the API call is successful
        notificationService.success(
            'Molimo Vas provjerite Vaš email. Poslali smo Vam kod za promjenu lozinke.');
        setState(() {
          showPasswordFields = true; // Update UI if needed
        });
      }
    } catch (err) {

    }
  }
  Future<void> handleChangePassword(String password, String code) async{
    try {
      UserChangePasswordRequest request=new UserChangePasswordRequest(code,password);
      // Call the forgotPassword method
      bool? result = await _userProvider.changePassword(request);

      if (result == true) {
        _authenticationProvider.logout(context);
      }
    } catch (err) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promjena lozinke'),
        backgroundColor: const Color(0xFF3A7BD5),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!showPasswordFields) ...[
              const Text(
                "Da li želite da promijenite lozinku?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  sendEmail();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A6FF),
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 8.0, // Adds a slight shadow for depth
                  shadowColor: Colors.black26,
                ),
                child: const Text(
                  "Promijeni lozinku",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2, // Slightly increase spacing for readability
                  ),
                ),
              ),

            ],
            if (showPasswordFields)
              FormBuilder(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FormBuilderTextField(
                      name: 'password',
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Lozinka",
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
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
                      name: 'repeatPassword',
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Ponovljena lozinka",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (value) {
                        final password = _formKey.currentState?.fields['password']?.value;
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
                      name: 'kod',
                      decoration: InputDecoration(
                        labelText: "Kod",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Kod je obavezno polje";
                        }
                        if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                          return "Kod mora sadržavati tačno 4 cifre";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.save();
                        if (_formKey.currentState!.validate()) {
                          final password =
                              _formKey.currentState?.fields['password']?.value;

                          final code =
                              _formKey.currentState?.fields['kod']?.value;
                          handleChangePassword(password, code);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3A7BD5),
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text("Pošalji"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
