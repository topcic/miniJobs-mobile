import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_mobile/models/auth_code_request.dart';
import 'package:minijobs_mobile/providers/authentication_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:minijobs_mobile/widgets/navbar.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  late AuthenticationProvider _authenticationProvider;

  @override
  void initState() {
    super.initState();
    authenticateUserOnInit();
  }

  // Run authentication process on init
  void authenticateUserOnInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Ensure provider is available after initial build
      _authenticationProvider = context.read<AuthenticationProvider>();
      authenticateUser();
    });
  }

  // Method to authenticate user
  Future<void> authenticateUser() async {
    var autCodeRequest = AuthCodeRequest(
      "27topcic.mahir+aplikant@gmail.com",
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Nevalidna lozinka ili email'),
      ));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authenticationProvider = context.read<AuthenticationProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prijavi se"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: FormBuilder(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    rowMethod(
                      Expanded(
                        child: FormBuilderTextField(
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
                          decoration: const InputDecoration(
                            label: Text('Email'),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    rowMethod(
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'password',
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Lozinka je obavezno polje";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Lozinka"),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 55),
                    ElevatedButton(
                      onPressed: () async {
                        _formKey.currentState?.save();
                        if (_formKey.currentState!.validate()) {
                          final Map<String, dynamic> formValues =
                              _formKey.currentState!.value;
                          final String email = formValues['email'] ?? '';
                          final String password = formValues['password'] ?? '';
                          var autCodeRequest = AuthCodeRequest(
                              email, password, "password", "", "");

                          var result = await _authenticationProvider
                              .tokens(autCodeRequest);

                          if (result && mounted) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Navbar()),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Nevalidna lozinka ili email'),
                            ));
                            _formKey.currentState?.reset();
                          }
                        }
                      },
                      child: const Text('Log in'),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
