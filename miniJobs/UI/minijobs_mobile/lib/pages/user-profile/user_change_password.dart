import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/user/user_change_password_request.dart';
import '../../providers/authentication_provider.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../services/notification.service.dart';

class UserChangePassword extends StatefulWidget {
  const UserChangePassword({super.key});

  @override
  _UserChangePasswordState createState() => _UserChangePasswordState();
}

class _UserChangePasswordState extends State<UserChangePassword> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _passwordFocus = FocusNode();
  final _repeatPasswordFocus = FocusNode();
  final _codeFocus = FocusNode();
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

  @override
  void dispose() {
    _passwordFocus.dispose();
    _repeatPasswordFocus.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  Future<void> sendEmail() async {
    try {
      final email = GetStorage().read('emailaddress') ?? '';
      final result = await _userProvider.forgotPassword(email);
      if (result == true && mounted) {
        notificationService.success(
            'Molimo Vas provjerite Vaš email. Poslali smo Vam kod za promjenu lozinke.');
        setState(() {
          showPasswordFields = true;
        });
      } else {
        notificationService.error('Greška pri slanju emaila.');
      }
    } catch (err) {
      if (mounted) {
        notificationService.error('Došlo je do greške: $err');
      }
    }
  }

  Future<void> handleChangePassword(String password, String code) async {
    try {
      final request = UserChangePasswordRequest(code, password);
      final result = await _userProvider.changePassword(request);
      if (result == true && mounted) {
        notificationService.success('Lozinka uspješno promijenjena.');
        _authenticationProvider.logout(context);
      } else {
        notificationService.error('Nevažeći kod ili greška pri promjeni lozinke.');
      }
    } catch (err) {
      if (mounted) {
        notificationService.error('Došlo je do greške: $err');
      }
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
                onPressed: sendEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A6FF),
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 36.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 8.0,
                  shadowColor: Colors.black26,
                ),
                child: const Text(
                  "Promijeni lozinku",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
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
                      focusNode: _passwordFocus,
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
                            !RegExp(r'[A-Z]').hasMatch(value) ||
                            !RegExp(r'[a-z]').hasMatch(value) ||
                            !RegExp(r'[0-9]').hasMatch(value)) {
                          return "Lozinka mora sadržavati najmanje 8 karaktera, velika i mala slova i brojeve";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    FormBuilderTextField(
                      name: 'repeatPassword',
                      obscureText: true,
                      focusNode: _repeatPasswordFocus,
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
                      focusNode: _codeFocus,
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
                        if (_formKey.currentState!.saveAndValidate()) {
                          final password = _formKey.currentState!.fields['password']!.value;
                          final code = _formKey.currentState!.fields['kod']!.value;
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