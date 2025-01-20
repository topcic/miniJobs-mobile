import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/providers/city_provider.dart';
import 'package:minijobs_admin/providers/job_provider.dart';
import 'package:minijobs_admin/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class JobStep1 extends StatefulWidget {
  const JobStep1({super.key});

  @override
  JobStep1State createState() => JobStep1State();
}

class JobStep1State extends State<JobStep1> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<City>? cities;
  late CityProvider _cityProvider;
  late JobProvider _jobProvider;
  Job? _job;
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cityProvider = context.read<CityProvider>();
    _jobProvider = context.read<JobProvider>();

    if (cities == null) {
      getCities();
    } else {
      _job = _jobProvider.getCurrentJob();
      _setInitialFormValues();
    }
  }

  Future<void> getCities() async {
    try {
      cities = await _cityProvider.getAll();
      if (mounted) {
        setState(() {
          isLoading = false;
          _job = _jobProvider.getCurrentJob();
          _setInitialFormValues();
        });
      }
    } catch (e) {
      // Handle errors properly
      log('Error fetching cities: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setInitialFormValues() {
    if (_job != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.patchValue({
          'name': _job!.name,
          'description': _job!.description,
          'cityId': _job!.cityId?.toString(),
          'streetAddressAndNumber': _job!.streetAddressAndNumber,
        });
      });
    }
  }
  @override
  void dispose() {
    _formKey.currentState?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
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
              const SizedBox(height: 20),
              rowMethod(
                Expanded(
                  child: FormBuilderTextField(
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    name: 'description',
                    decoration: const InputDecoration(
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
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                CrossAxisAlignment.center,
              ),
              const SizedBox(height: 20),
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
                    decoration: const InputDecoration(
                      labelText: "Grad",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    items: cities?.map((g) {
                      return DropdownMenuItem(
                        value: g.id.toString(),
                        child: Text(
                          g.name ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList() ??
                        [],
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
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
        var job = Job.fromJson(formData);
        if (_job == null) {
          _job = job;
        } else {
          _job!.name = job.name;
          _job!.description = job.description;
          _job!.cityId = job.cityId;
          _job!.streetAddressAndNumber = job.streetAddressAndNumber;
        }
      });
      return true;
    }
    return false;
  }
  bool isValidForm(){
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  Job getUpdatedJob() {
    return _job!;
  }
}
