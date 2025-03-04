import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/country.dart';
import 'package:minijobs_admin/providers/country_provider.dart';
import 'package:provider/provider.dart';

// The CountryForm widget remains unchanged
class CountryForm extends StatefulWidget {
  final Country? country;

  const CountryForm({super.key, this.country});

  @override
  _CountryFormState createState() => _CountryFormState();
}

class _CountryFormState extends State<CountryForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late CountryProvider _countryProvider;

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
                  decoration: const InputDecoration(
                    labelText: 'Naziv',
                    labelStyle: TextStyle(fontSize: 14),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Naziv je obavezno polje';
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
          onPressed: () => Navigator.pop(context, false),
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
                    Navigator.pop(context, true); // Return true on success
                  }
                } else {
                  var response = await _countryProvider.update(widget.country!.id!, newCountry);
                  if (response != null && response.id != null) {
                    Navigator.pop(context, true); // Return true on success
                  }
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Greška: $e')),
                );
              }
            }
          },
          child: const Text('Spasi'),
        ),
      ],
    );
  }
}

// Helper function to open CountryForm without showDialog
void openCountryForm(BuildContext context, Country? country, Function fetchCountries) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Scaffold(
        
        body: Center(
          child: CountryForm(country: country),
        ),
      ),
      fullscreenDialog: true, // Makes it behave like a dialog
    ),
  ).then((value) {
    if (value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchCountries();
      });
    }
  });
}