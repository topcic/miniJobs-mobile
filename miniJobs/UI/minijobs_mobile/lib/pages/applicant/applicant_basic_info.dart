import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';

import '../../models/applicant/applicant_save_request.dart';

class ApplicantBasicInfo extends StatefulWidget {
  final int applicantId;
  const ApplicantBasicInfo({super.key, required this.applicantId});

  @override
  State<ApplicantBasicInfo> createState() => _ApplicantBasicInfoState();
}

class _ApplicantBasicInfoState extends State<ApplicantBasicInfo> {
  final _formKey = GlobalKey<FormBuilderState>();
  late ApplicantProvider applicantProvider;
  late CityProvider cityProvider;

  List<City>? cities;
  Applicant? applicant;
  bool isLoading = true;

  final phoneNumberMask = MaskTextInputFormatter(
    mask: '+387 ## #######',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    applicantProvider = context.read<ApplicantProvider>();
    cityProvider = context.read<CityProvider>();
    getApplicant();
    getCities();
  }

  Future<void> getApplicant() async {
    applicant = await applicantProvider.get(widget.applicantId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCities() async {
    cities = await cityProvider.getAll();
    setState(() {});
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final formData = _formKey.currentState!.value;
      final request = ApplicantSaveRequest(
          formData['firstName'],
          formData['lastName'],
          formData['phoneNumber'],
          int.tryParse(formData['cityId']),
          applicant?.description,
          applicant?.experience,
          applicant?.wageProposal,
          applicant?.cv,
          null);

      try {
        await applicantProvider.update(widget.applicantId, request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save changes: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SpinKitRing(color: Colors.brown)
        : SingleChildScrollView(
            child: FormBuilder(
              key: _formKey,
              initialValue: applicant != null
                  ? {
                      'firstName': applicant!.firstName,
                      'lastName': applicant!.lastName,
                      'cityId': applicant!.cityId?.toString(),
                      'phoneNumber': applicant!.phoneNumber,
                      'email': applicant!.email,
                    }
                  : {},
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (applicant != null) ...[
                      _buildTextField('firstName', 'Ime'),
                      const SizedBox(height: 16),
                      _buildTextField('lastName', 'Prezime'),
                      const SizedBox(height: 16),
                      FormBuilderDropdown<String>(
                        name: 'cityId',
                        decoration: const InputDecoration(labelText: 'Grad'),
                        validator: (value) {
                          if (value == null) {
                            return 'City is required';
                          }
                          return null;
                        },
                        items: cities != null
                            ? cities!.map((city) {
                                return DropdownMenuItem(
                                  value: city.id.toString(),
                                  child: Text(city.name ?? ''),
                                );
                              }).toList()
                            : [],
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('phoneNumber', 'Broj telefona',
                          mask: phoneNumberMask),
                      const SizedBox(height: 16),
                      _buildTextField('email', 'Email', readOnly: true),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _saveChanges,
                              child: const Text('Spasi promjene'),
                            ),
                          )
                        ],
                      )
                    ],
                  ],
                ),
              ),
            ),
          );
  }

  Widget _buildTextField(String name, String label,
      {TextInputFormatter? mask, bool readOnly = false}) {
    return FormBuilderTextField(
      name: name,
      readOnly: readOnly,
      inputFormatters: mask != null ? [mask] : null,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label je obavezno polje.';
        }
        return null;
      },
    );
  }
}
