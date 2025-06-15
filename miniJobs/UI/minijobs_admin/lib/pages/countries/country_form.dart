import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/country.dart';
import 'package:minijobs_admin/providers/country_provider.dart';
import 'package:provider/provider.dart';

class CountryForm extends StatefulWidget {
  final Country? country;
  final Function({bool success}) onClose;

  const CountryForm({super.key, this.country, required this.onClose});

  @override
  _CountryFormState createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late CountryProvider _countryProvider;
  String? _nameError; // To store the custom error message for the name field

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _countryProvider = context.read<CountryProvider>();

    if (widget.country != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.patchValue({
          'name': widget.country!.name,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.country == null ? 'Dodaj Državu' : 'Uredi Državu'),
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
                    errorText: _nameError, // Display custom error message here
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Naziv je obavezno polje';
                    }
                    return null; // Default validation; custom error handled separately
                  },
                  style: const TextStyle(fontSize: 12),
                  onChanged: (_) {
                    // Clear custom error when user starts typing
                    if (_nameError != null) {
                      setState(() {
                        _nameError = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => widget.onClose(success: false),
          // Close without saving
          child: const Text('Odustani'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              final formData = _formKey.currentState!.value;
              try {
                Country newCountry = Country(
                  widget.country?.id ?? 0,
                  formData['name'],
                  widget.country?.isDeleted ?? false,
                );

                if (widget.country == null) {
                  var response = await _countryProvider.insert(newCountry);
                  if (response != null && response.id != null) {
                    widget.onClose(success: true); // Close with success
                  }
                } else {
                  var response = await _countryProvider.update(
                      widget.country!.id!, newCountry);
                  if (response != null && response.id != null) {
                    widget.onClose(success: true); // Close with success
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
