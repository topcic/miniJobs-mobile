import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_admin/models/auth_code_request.dart';
import 'package:minijobs_admin/pages/login_page.dart';
import 'package:minijobs_admin/providers/authentication_provider.dart';
import 'package:minijobs_admin/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatefulWidget {
  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  String verificationCode = '';
  late AuthenticationProvider _authenticationProvider =
      AuthenticationProvider();
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
          title: Text('Verifikacija emaila'),
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
                SizedBox(height: 20),
                Text(
                  'Unesite kod koji ste dobili na Vaš email',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                rowMethod(Expanded(
                  child: FormBuilderTextField(
                    inputFormatters: [numberMask],
                    decoration: InputDecoration(
                      labelText: 'Verifikacijski kod',
                      border: OutlineInputBorder(),
                    ),
                    name: 'verificationCode',
                    validator: (value) {
                      if (value == null) {
                        return "erifikacijski kod je obavezno polje";
                      } else {
                        return null;
                      }
                    },
                  ),
                )),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    _formKey.currentState?.save();
                    if (_formKey.currentState!.validate()) {
                      var autCodeRequest = AuthCodeRequest(
                          "", "", "authcode", "", verificationCode);
                      var result =
                          await _authenticationProvider.tokens(autCodeRequest);

                      if (result == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Uspješno ste potvrdili Vaš email. Molimo Vas prijavite se.")));
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginPage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Verifikacijski kod nije validan.")));
                      }
                    }
                  },
                  child: Text('Pošalji'),
                ),
              ],
            ),
          ),
        ));
  }
}
