import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/pages/verification_page.dart';
import 'package:minijobs_admin/providers/city_provider.dart';
import 'package:minijobs_admin/providers/employer_provider.dart';
import 'package:provider/provider.dart';
import '../utils/util_widgets.dart';

class CompanyEmployerSignupPage extends StatefulWidget {
  const CompanyEmployerSignupPage({Key? key}) : super(key: key);

  @override
  State<CompanyEmployerSignupPage> createState() =>
      _CompanyEmployerSignupPageState();
}

class _CompanyEmployerSignupPageState extends State<CompanyEmployerSignupPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<City>? cities;
  bool isLoading = true;
  final phoneNumberMask = MaskTextInputFormatter(
    mask: '+387 ## #######',
    filter: {'#': RegExp(r'[0-9]')},
  );
  final idNumberMask = MaskTextInputFormatter(
    mask: '4############',
    filter: {'#': RegExp(r'[0-9]')},
  );

  late CityProvider _cityProvider = CityProvider();
  late EmployerProvider _userCompanyProvider = EmployerProvider();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cityProvider = context.read<CityProvider>();
    _userCompanyProvider = context.read<EmployerProvider>();
  }

  @override
  void initState() {
    super.initState();

    intiForm();
    getCities();
  }

  Future<void> getCities() async {
    cities = await _cityProvider.get();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Registruj se kao poslodavac"),
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
                          Image.asset("assets/images/logo.png",
                              height: 150, width: 150),
                          Row(
                            children: [
                              Expanded(
                                  child: Divider()), // First divider widget
                              SizedBox(
                                  width:
                                      10), // Spacer between first divider and text
                              Text(
                                'Podaci o firmi', // Your text
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      10), // Spacer between text and second divider
                              Expanded(
                                  child: Divider()), // Second divider widget
                            ],
                          ),
                          rowMethod(
                            _textField('name', "Naziv firme"),
                            CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 20),
                          rowMethod(
                            _textField('streetAddressAndNumber',
                                "Adresa i broj ulice"),
                            CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 20),
                          rowMethod(
                            Expanded(
                              child: FormBuilderDropdown<String>(
                                name: 'cityId',
                                validator: (value) {
                                  if (value == null) {
                                    return "Sjedište firme je obavezno polje";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Sjedište firme",
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
                          SizedBox(height: 20),
                          rowMethod(
                            Expanded(
                              child: FormBuilderTextField(
                                  inputFormatters: [idNumberMask],
                                  name: 'idNumber',
                                  decoration: InputDecoration(
                                    label: Text("ID broj"),
                                  ),
                                  validator: ((value) {
                                    if (value == null || value.isEmpty) {
                                      return "ID broj je obavezno polje";
                                    }
                                    return null;
                                  })),
                            ),
                            CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 40),
                          Row(
                            children: [
                              Expanded(
                                  child: Divider()), // First divider widget
                              SizedBox(
                                  width:
                                      10), // Spacer between first divider and text
                              Text(
                                'Odgovorno lice', // Your text
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                  width:
                                      10), // Spacer between text and second divider
                              Expanded(
                                  child: Divider()), // Second divider widget
                            ],
                          ),
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
                                  inputFormatters: [phoneNumberMask],
                                  name: 'companyPhoneNumber',
                                  decoration: InputDecoration(
                                    label: Text("Službeni telefon"),
                                  ),
                                  validator: ((value) {
                                    if (value == null || value.isEmpty) {
                                      return "Službeni telefon je obavezno polje";
                                    }
                                    return null;
                                  })),
                            ),
                            CrossAxisAlignment.center,
                          ),
                          SizedBox(height: 20),
                          rowMethod(
                            Expanded(
                              child: FormBuilderTextField(
                                inputFormatters: [phoneNumberMask],
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
                            mainAxisAlignment: MainAxisAlignment.center,
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
                                        var result = await _userCompanyProvider
                                            .insert(request);
                                        if (result != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      "Uspješno ste se registrovali. Molimo Vas provjerite Vaš email")));

                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerificationPage()));
                                        }
                                      } else {}
                                    } catch (e) {
                                       ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  " Email adresa se već koristi. Molimo izaberite drugu email adresu.")));
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
