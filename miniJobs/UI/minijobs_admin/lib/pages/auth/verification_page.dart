import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_admin/models/auth_code_request.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

import '../../services/notification.service.dart';
import 'login_page.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final notificationService = NotificationService();
  late AuthenticationProvider _authenticationProvider;
  final numberMask = MaskTextInputFormatter(
    mask: '####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider = context.read<AuthenticationProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width
    final screenHeight = MediaQuery.of(context).size.height; // Get screen height

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikacija emaila'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Determine adaptive sizes
          double imageHeight = constraints.maxHeight * 0.3; // 30% of height
          double spacing = screenWidth * 0.05; // 5% of width for spacing

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: spacing, vertical: spacing),
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: imageHeight,
                    child: Image.asset(
                      "assets/images/verify-mail2.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: spacing),
                  const Text(
                    'Unesite kod koji ste dobili na Vaš email',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: spacing),
                  FormBuilderTextField(
                    inputFormatters: [numberMask],
                    decoration: const InputDecoration(
                      labelText: 'Verifikacijski kod',
                      border: OutlineInputBorder(),
                    ),
                    name: 'verificationCode',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Verifikacijski kod je obavezno polje";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: spacing),
                  ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate()) {
                        final verificationCode = _formKey
                            .currentState?.fields['verificationCode']?.value;
                        var authCodeRequest = AuthCodeRequest(
                          "", "", "authcode", "", verificationCode,
                        );
                        var result =
                        await _authenticationProvider.tokens(authCodeRequest);

                        if (result) {
                          notificationService.success("Uspješno ste potvrdili Vaš email. Molimo Vas prijavite se.");
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ));
                        } else {
                          notificationService.error("Verifikacijski kod nije validan.");
                        }
                      }
                    },
                    child: const Text('Pošalji'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}