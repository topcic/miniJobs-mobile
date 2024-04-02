import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minijobs_admin/enumerations/gender.dart';
import 'package:minijobs_admin/models/city.dart';
import '../models/search_result.dart';
import '../utils/util_widgets.dart';

class ApplicantSignupPage extends StatefulWidget {
  const ApplicantSignupPage({Key? key}) : super(key: key);

  @override
  State<ApplicantSignupPage> createState() => _ApplicantSignupPageState();
}

class _ApplicantSignupPageState extends State<ApplicantSignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  SearchResult<City>? cityResult;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    intiForm();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Registruj se kao aplikant"),
        centerTitle: true,
      ),
      body: isLoading
          ? const SpinKitRing(color: Colors.brown)
          : SingleChildScrollView(
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
                          rowMethod(
                            _textField('firstName', "Ime"),
                            CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 20),
                          rowMethod(
                            _textField('lastName', "Prezime"),
                            CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 20),
                          rowMethod(
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'phoneNumber',
                                decoration: InputDecoration(
                                  label: Text("Broj telefona"),
                                ),
                              ),
                            ),
                            CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 20),
                          rowMethod(
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'gender',
                                validator: (value) {
                                  if (value == null) {
                                    return "Spol je obavezno polje";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Spol",
                                ),
                                items: Gender.values.map((gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender.toString(),
                                    child:
                                        Text(gender.toString().split('.').last),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
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
                                decoration: InputDecoration(
                                  labelText: "Grad",
                                ),
                                items: cityResult?.result!
                                        .map((g) => DropdownMenuItem(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              value: g.id.toString(),
                                              child: Text(g.name ?? ''),
                                            ))
                                        .toList() ??
                                    [],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
                          rowMethod(
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'password',
                                obscureText: true,
                                validator: ((value) {
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
                                }),
                                decoration: InputDecoration(
                                  label: Text("Lozinka"),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(height: 20),
                          rowMethod(
                            Expanded(
                              child: FormBuilderTextField(
                                name: 'repeatPassword',
                                obscureText: true,
                                validator: ((value) {
                                  final password = _formKey
                                      .currentState!.fields['password']?.value;
                                  if (value == null || value.isEmpty) {
                                    return "Ponovljena lozinka je obavezno polje";
                                  } else if (value != password) {
                                    return "Lozinke nisu iste";
                                  } else {
                                    return null;
                                  }
                                }),
                                decoration: InputDecoration(
                                  label: Text("Ponovljena lozinka"),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      _formKey.currentState?.save();
                                      if (_formKey.currentState!.validate()) {
                                        Map<String, dynamic> request = Map.of(
                                            _formKey.currentState!.value);

                                        request['isActive'] = true;

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                "AppLocalizations.of(context).su_sign_up"),
                                          ),
                                        );

                                        Navigator.pop(context);
                                      } else {}
                                    } catch (e) {
                                      // alertBox(
                                      //     context,
                                      //     AppLocalizations.of(context).error,
                                      //     e.toString());
                                    }
                                  },
                                  child: Text("Registruj se"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
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
