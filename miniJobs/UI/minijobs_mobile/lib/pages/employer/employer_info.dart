import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:minijobs_mobile/utils/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/employer.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/employer_provider.dart';// Import the PhotoView widget

class EmployerInfo extends StatefulWidget {
  final int employerId;
  const EmployerInfo({super.key, required this.employerId});

  @override
  State<EmployerInfo> createState() => _EmployerInfoState();
}

class _EmployerInfoState extends State<EmployerInfo> {
  final _formKey = GlobalKey<FormBuilderState>();
  late EmployerProvider employerProvider;
  late CityProvider cityProvider;

  List<City>? cities;
  Employer? employer;
  bool isLoading = true;

  final phoneNumberMask = MaskTextInputFormatter(
    mask: '+387 ## #######',
    filter: {'#': RegExp(r'[0-9]')},
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    employerProvider = context.read<EmployerProvider>();
    cityProvider = context.read<CityProvider>();
    getEmployer();
    getCities();
  }

  Future<void> getEmployer() async {
    employer = await employerProvider.get(widget.employerId);
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getCities() async {
    cities = await cityProvider.getAll();
    setState(() {});
  }

  void _updatePhoto(Uint8List? newPhoto) {
    setState(() {
      employer?.photo = newPhoto;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employer Info'),
        centerTitle: true,
      ),
      body: isLoading
          ? const SpinKitRing(color: Colors.brown)
          : SingleChildScrollView(
              child: FormBuilder(
                key: _formKey,
                initialValue: employer != null
                    ? {
                        'name': employer!.name,
                        'streetAddressAndNumber': employer!.streetAddressAndNumber,
                        'cityId': employer!.cityId?.toString(),
                        'idNumber': employer!.idNumber,
                        'firstName': employer!.firstName,
                        'lastName': employer!.lastName,
                        'phoneNumber': employer!.phoneNumber,
                        'email': employer!.email,
                      }
                    : {},
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      PhotoView(
                        photo: employer?.photo,
                        editable: true,
                        onPhotoChanged: _updatePhoto,
                      ),
                      const SizedBox(height: 16),
                      if (employer?.name != null) ...[
                        const Text(
                          'Company Information',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('name', 'Company Name'),
                        const SizedBox(height: 16),
                        _buildTextField('streetAddressAndNumber', 'Street Address and Number'),
                        const SizedBox(height: 16),
                        FormBuilderDropdown<String>(
                          name: 'cityId',
                          decoration: const InputDecoration(labelText: 'City'),
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
                        _buildTextField('idNumber', 'ID Number', mask: MaskTextInputFormatter(
                          mask: '4############',
                          filter: {'#': RegExp(r'[0-9]')}
                        )),
                      ],
                      const SizedBox(height: 16),
                      const Text(
                        'Personal Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField('firstName', 'First Name'),
                      const SizedBox(height: 16),
                      _buildTextField('lastName', 'Last Name'),
                      const SizedBox(height: 16),
                      _buildTextField('phoneNumber', 'Phone Number', mask: phoneNumberMask),
                      const SizedBox(height: 16),
                      _buildTextField('email', 'Email', readOnly: true),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Handle save action
                          }
                        },
                        child: const Text('Save Changes'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String name, String label, {TextInputFormatter? mask, bool readOnly = false}) {
    return FormBuilderTextField(
      name: name,
      readOnly: readOnly,
      inputFormatters: mask != null ? [mask] : null,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
