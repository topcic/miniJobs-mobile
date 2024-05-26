import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class JobStep1 extends StatefulWidget {
  JobStep1({Key? key}) : super(key: key);

  @override
  JobStep1State createState() => JobStep1State();
}

class JobStep1State extends State<JobStep1> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<City>? cities;
  late CityProvider _cityProvider;
  late JobProvider _jobProvider;
  late Job? _job;
  
   @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cityProvider = context.read<CityProvider>();
    getCities();
     _jobProvider = Provider.of<JobProvider>(context);

    setState(() {
      _job = _jobProvider.getCurrentJob();
      if(_job!=null)
       _setInitialFormValues();
    });
  }

  void _setInitialFormValues() {
    _formKey.currentState?.patchValue({
      'name': _job!.name,
      'description': _job!.description,
      'cityId': _job!.cityId.toString(),
      'streetAddressAndNumber': _job!.streetAddressAndNumber,
    });
  }

  Future<void> getCities() async {
    cities = await _cityProvider.getAll();
       _setInitialFormValues();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: FormBuilderTextField(
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    name: 'description',
                    decoration: InputDecoration(
                      labelText: "Opis",
                      hintText: "Unesite opis ovdje",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Opis je obavezno polje";
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 12),
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
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Grad",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    items: cities?.map((g) {
                          return DropdownMenuItem(
                            value: g.id.toString(),
                            child: Text(
                              g.name ?? '',
                              style: TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList() ??
                        [],
                  ),
                ),
              ),
              SizedBox(height: 20),
              rowMethod(
                _textField('streetAddressAndNumber', "Adresa"),
                CrossAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _textField(String name, String label) {
    return Expanded(
      child: FormBuilderTextField(
        name: name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label je obavezno polje";
          }
          return null;
        },
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  bool validateAndSave() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
     final formData = Map<String, dynamic>.from(_formKey.currentState!.value);
     formData['cityId'] = int.tryParse(formData['cityId']);

    setState(() {
       var job= Job.fromJson(formData);
       _job!.name=job.name;
       _job!.description=job.description;
       _job!.cityId=job.cityId;
       _job!.streetAddressAndNumber=job.streetAddressAndNumber;
    });
      return true;
    }
    return false;
  }

   Job getUpdatedJob() {
    return _job!;
  }
}
