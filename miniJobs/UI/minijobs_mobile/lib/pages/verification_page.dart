import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_mobile/models/auth_code_request.dart';
import 'package:minijobs_mobile/pages/login_page.dart';
import 'package:minijobs_mobile/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormBuilderState>();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikacija emaila'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/verify-mail2.png",
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'Unesite kod koji ste dobili na Vaš email',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    final verificationCode = _formKey.currentState?.fields['verificationCode']?.value;
                    var authCodeRequest = AuthCodeRequest(
                      "", "", "authcode", "", verificationCode,
                    );
                    var result = await _authenticationProvider.tokens(authCodeRequest);

                    if (result) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Uspješno ste potvrdili Vaš email. Molimo Vas prijavite se."),
                      ));
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Verifikacijski kod nije validan."),
                      ));
                    }
                  }
                },
                child: const Text('Pošalji'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
