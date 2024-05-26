import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class JobStep1Page extends StatelessWidget {
  final VoidCallback onNextPressed;
  JobStep1Page({required this.onNextPressed});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200, // Customize height here
              color: Colors.blue[100],
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Dodaj osnovne informacije',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(
                height: 400, child: JobForm(onNextPressed: onNextPressed)),
          ),
        ],
      ),
    );
  }
}

class JobForm extends StatefulWidget {
     final VoidCallback onNextPressed;
  
  JobForm({required this.onNextPressed});
  @override
  _JobFormState createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<City>? cities;
  late CityProvider _cityProvider = CityProvider();
late JobProvider _jobProvider=JobProvider();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cityProvider = context.read<CityProvider>();
    _jobProvider = context.read<JobProvider>();
  }

  @override
  void initState() {
    super.initState();
    getCities();
  }

  Future<void> getCities() async {
    cities = await _cityProvider.getAll();

    setState(() {});
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: FormBuilder(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  rowMethod(
                    _textField('name', "Naziv posla"),
                    CrossAxisAlignment.center,
                  ),
                  SizedBox(height: 20),
                  rowMethod(
                    Expanded(
                      child: Container(
                        child: FormBuilderTextField(
                          maxLines: 8,
                          keyboardType: TextInputType.multiline,
                          name: 'description',
                          decoration: InputDecoration(
                            labelText: "Opis",
                            hintText: "Unesite opis ovdje",
                            border: OutlineInputBorder(),
                          ),
                          validator: ((value) {
                            if (value == null || value.isEmpty) {
                              return "Opis je obavezno polje";
                            }
                            return null;
                          }),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                    CrossAxisAlignment.center,
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
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        items: cities != null
                            ? cities!.map((g) {
                                return DropdownMenuItem(
                                  value: g.id.toString(),
                                  child: Text(
                                    g.name ?? '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              }).toList()
                            : [],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  rowMethod(
                    _textField('streetAddressAndNumber', "Adresa"),
                    CrossAxisAlignment.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.save();
                          if (_formKey.currentState!.validate()) {
                            final Map<String, dynamic>? formValues =
                                _formKey.currentState!.value;
                           
                            var job =
                                await _jobProvider.insert(formValues);
                            if (job != null) {
                              _jobProvider.setCurrentJob(job);
                              widget.onNextPressed();
                            }
                          }
                        },
                        child: Text('Dalje'),
                      ),
                    ],
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
      style: TextStyle(fontSize: 12),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 14),
      ),
    ),
  );
}
