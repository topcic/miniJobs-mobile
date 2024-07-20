import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minijobs_mobile/models/city.dart';
import '../models/search_result.dart';
import '../utils/util_widgets.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  SearchResult<City>? cityResult;
  bool isLoading = true;
  String title = "Dodaj novog korisnika";

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
        title: Text(title),
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
                          const SizedBox(height: 20),
                          rowMethod(
                            _textField('lastName', "Prezime"),
                            CrossAxisAlignment.center,
                          ),
                          const SizedBox(height: 20),
                          rowMethod(
                            _textField('phoneNumber', "Broj telefona"),
                            CrossAxisAlignment.center,
                          ),
                          const SizedBox(height: 20),
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
