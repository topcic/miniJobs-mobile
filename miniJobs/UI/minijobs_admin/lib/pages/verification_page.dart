import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:minijobs_admin/models/auth_code_request.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  String verificationCode = '';
  late AuthenticationProvider _authenticationProvider =
      AuthenticationProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider = context.read<AuthenticationProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verifikacija emaila'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              "assets/images/verify-mail2.png",
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              'Unesite kod koji ste dobili na Vaš email',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  verificationCode = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Verifikacijski kod',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                var autCodeRequest =
                    AuthCodeRequest("", "", "authcode", "", verificationCode);
                var result =
                    await _authenticationProvider.tokens(autCodeRequest);
              },
              child: Text('Pošalji'),
            ),
          ],
        ),
      ),
    );
  }
}
