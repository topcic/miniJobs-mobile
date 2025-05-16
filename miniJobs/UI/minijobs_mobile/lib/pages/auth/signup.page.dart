import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_mobile/enumerations/role.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/pages/auth/verification_page.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/user_registration_provider.dart';
import 'package:provider/provider.dart';

import '../../helpers/auth_helper.dart';
import '../../services/notification.service.dart';
import '../../utils/util_widgets.dart';

class SignupPage extends StatefulWidget {
  final Role role;

  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final notificationService = NotificationService();
  final _formKey = GlobalKey<FormBuilderState>();
  List<City>? cities;
  bool isLoading = true;

  late final String title = widget.role == Role.Applicant
      ? "Registruj se kao aplikant"
      : "Registruj se kao poslodavac";
  late CityProvider _cityProvider = CityProvider();
  late UserRegistrationProvider _userRegistrationProvider =
      UserRegistrationProvider();

  final maskFormatter = MaskTextInputFormatter(
    mask: '+387 ## #######',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cityProvider = context.read<CityProvider>();
    _userRegistrationProvider = context.read<UserRegistrationProvider>();
    AuthHelper.checkIsAuthenticated(context);
  }

  @override
  void initState() {
    super.initState();

    intiForm();
    getCities();
  }

  Future<void> getCities() async {
    cities = await _cityProvider.getAll();
    setState(() {});
  }

  Future<void> intiForm() async {
    try {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          centerTitle: true,
        ),
        body: isLoading
            ? const SpinKitRing(color: Colors.brown)
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
                  ),
                ),
                child: SingleChildScrollView(
                  child: FormBuilder(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(45, 20, 45, 20),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              // Logo Section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/logo.png",
                                      height: screenHeight * 0.2,
                                      // 20% of screen height
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),

                              // First Name Field
                              rowMethod(
                                _textField('firstName', "Ime"),
                                CrossAxisAlignment.center,
                              ),
                              const SizedBox(height: 20),

                              // Last Name Field
                              rowMethod(
                                _textField('lastName', "Prezime"),
                                CrossAxisAlignment.center,
                              ),
                              const SizedBox(height: 20),

                              // Phone Number Field
                              rowMethod(
                                Expanded(
                                  child: FormBuilderTextField(
                                    inputFormatters: [maskFormatter],
                                    name: 'phoneNumber',
                                    decoration: const InputDecoration(
                                      label: Text("Broj telefona"),
                                    ),
                                  ),
                                ),
                                CrossAxisAlignment.center,
                              ),
                              const SizedBox(height: 20),

                              // City Dropdown
                              rowMethod(
                                Expanded(
                                  child: FormBuilderDropdown<String>(
                                    name: 'cityId',
                                    validator: (value) {
                                      if (value == null) {
                                        return "Grad je obavezno polje";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Grad",
                                    ),
                                    items: cities != null
                                        ? cities!.map((g) {
                                            return DropdownMenuItem(
                                              value: g.id.toString(),
                                              child: Text(g.name ?? ''),
                                            );
                                          }).toList()
                                        : [],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Email Field
                              rowMethod(
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'email',
                                    validator: ((value) {
                                      if (value == null || value.isEmpty) {
                                        return "Email je obavezno polje";
                                      } else if (!RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value)) {
                                        return "Nevalidan format";
                                      } else {
                                        return null;
                                      }
                                    }),
                                    decoration: const InputDecoration(
                                      label: Text('Email'),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Password Field
                              rowMethod(
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'password',
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.black),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Lozinka je obavezno polje";
                                      } else if (value.length < 8 ||
                                          !value.contains(RegExp(r'[A-Z]')) ||
                                          !value.contains(RegExp(r'[a-z]')) ||
                                          !value.contains(RegExp(r'[0-9]'))) {
                                        return "Lozinka mora sadržavati najmanje 8 karaktera, velika i mala slova i brojeve";
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      label: Text("Lozinka"),
                                      errorStyle: TextStyle(
                                        fontSize: 12,
                                      ),
                                      errorMaxLines: 2,

                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Repeat Password Field
                              rowMethod(
                                Expanded(
                                  child: FormBuilderTextField(
                                    name: 'repeatPassword',
                                    obscureText: true,
                                    validator: ((value) {
                                      final password = _formKey.currentState!
                                          .fields['password']?.value;
                                      if (value == null || value.isEmpty) {
                                        return "Ponovljena lozinka je obavezno polje";
                                      } else if (value != password) {
                                        return "Lozinke nisu iste";
                                      } else {
                                        return null;
                                      }
                                    }),
                                    decoration: const InputDecoration(
                                      label: Text("Ponovljena lozinka"),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Submit Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 20.0),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          _formKey.currentState?.save();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            Map<String, dynamic> request =
                                                Map.of(_formKey
                                                    .currentState!.value);

                                            request['roleId'] =
                                                widget.role.name;
                                            var result =
                                                await _userRegistrationProvider
                                                    .insert(request);
                                            if (result != null &&
                                                result.isRegistered == true) {
                                              notificationService.success(
                                                  "Uspješno ste se registrovali. Molimo Vas provjerite Vaš email");
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const VerificationPage()));
                                            }
                                          }
                                        } catch (e) {
                                          notificationService.error(
                                              "Email adresa se već koristi. Molimo izaberite drugu email adresu");
                                        }
                                      },
                                      child: const Text("Registruj se"),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ));
  }

  Expanded _textField(String name, String label) {
    return Expanded(
      child: FormBuilderTextField(
        name: name,
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return "$label je obavezno polje";
          } else {
            return null;
          }
        }),
        decoration: InputDecoration(
          label: Text(label),
        ),
      ),
    );
  }
}
