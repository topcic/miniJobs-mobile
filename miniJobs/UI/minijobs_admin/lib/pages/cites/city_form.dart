import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/models/country.dart';
import 'package:minijobs_admin/providers/country_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/city_provider.dart';

class CityForm extends StatefulWidget {
  final City? city;
  final Function({bool success}) onClose;

  const CityForm({super.key, this.city, required this.onClose});

  @override
  _CityFormState createState() => _CityFormState();
}

class _CityFormState extends State<CityForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late CountryProvider countryProvider;
  List<Country> countries = [];
  String? _nameError;
  String? _countryError;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    countryProvider = context.read<CountryProvider>();
    try {
      var countryList = await countryProvider.getAll();
      setState(() {
        countries = countryList.where((x) => !x.isDeleted!).toList() ?? [];

        if (widget.city != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _formKey.currentState?.patchValue({
              'name': widget.city!.name,
              'countryId': widget.city!.countryId.toString(),
              'municipalityCode': widget.city!.municipalityCode,
              'postcode': widget.city!.postcode,
            });
          });
        }
      });
    } catch (e) {
      // Handle error if needed
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.city == null ? 'Dodaj grad' : 'Uredi grad'),
      content: SizedBox(
        width: 400,
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(
                    labelText: 'Naziv',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: const OutlineInputBorder(),
                    errorText: _nameError,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Naziv je obavezno polje';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 12),
                  onChanged: (_) {
                    if (_nameError != null) {
                      setState(() {
                        _nameError = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                FormBuilderDropdown<String>(
                  name: 'countryId',
                  decoration: InputDecoration(
                    labelText: 'Država',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: const OutlineInputBorder(),
                    errorText: _countryError,
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Država je obavezno polje';
                    }
                    return null;
                  },
                  items: countries
                      .map((country) => DropdownMenuItem(
                            value: country.id.toString(),
                            child: Text(country.name ?? ''),
                          ))
                      .toList(),
                  onChanged: (_) {
                    if (_countryError != null) {
                      setState(() {
                        _countryError = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'municipalityCode',
                  decoration: const InputDecoration(
                    labelText: 'Šifra opštine',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Dozvoljeni su samo brojevi';
                      }
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 16),
                FormBuilderTextField(
                  name: 'postcode',
                  decoration: const InputDecoration(
                    labelText: 'Poštanski broj',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'Dozvoljeni su samo brojevi';
                      }
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => widget.onClose(success: false),
          child: const Text('Odustani'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              final formData = _formKey.currentState!.value;
              try {
                City newCity = City(
                    widget.city?.id ?? 0,
                    formData['name'],
                    int.parse(formData['countryId']),
                    formData['municipalityCode'],
                    formData['postcode'],
                    widget.city?.isDeleted ?? false,
                    '');

                // Assuming you have a CityProvider
                var cityProvider = context.read<CityProvider>();
                if (widget.city == null) {
                  var response = await cityProvider.insert(newCity);
                  if (response != null && response.id != null) {
                    widget.onClose(success: true);
                  }
                } else {
                  var response =
                      await cityProvider.update(widget.city!.id!, newCity);
                  if (response != null && response.id != null) {
                    widget.onClose(success: true);
                  }
                }
              } catch (e) {
                final nameMessages = (e as Map<String, dynamic>)['Name'];
                final message =
                    (nameMessages is List && nameMessages.isNotEmpty)
                        ? nameMessages.first
                        : '';

                setState(() {
                  _nameError = message;
                  _formKey.currentState?.fields['name']?.invalidate(message!);
                });
                return;
              }
            }
          },
          child: const Text('Spasi'),
        ),
      ],
    );
  }
}
