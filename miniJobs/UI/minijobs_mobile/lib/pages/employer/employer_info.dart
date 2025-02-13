import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/employer/employer.dart';
import 'package:minijobs_mobile/models/employer/employer_save_request.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/employer_provider.dart';

import '../../services/notification.service.dart';
import '../../utils/photo_view.dart';

class EmployerInfo extends StatefulWidget {
  final int employerId;
  final VoidCallback onBack;
  const EmployerInfo({super.key, required this.employerId,required this.onBack});

  @override
  State<EmployerInfo> createState() => _EmployerInfoState();
}

class _EmployerInfoState extends State<EmployerInfo> {
  final notificationService = NotificationService();

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

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final formData = _formKey.currentState!.value;

      final request = EmployerSaveRequest(
        formData['name'],
        formData['streetAddressAndNumber'],
        formData['idNumber'],
        formData['companyPhoneNumber'],
        formData['firstName'],
        formData['lastName'],
        formData['phoneNumber'],
        int.tryParse(formData['cityId'])
      );

        await employerProvider.update(widget.employerId, request);
        notificationService.success('Uspješno spašene promjene');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Korisničke informacije'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.onBack(); // Call the callback when back button is pressed
            Navigator.pop(context, true); // Pass 'true' to indicate data should be fetched
          },
        ),
      ),
      body: isLoading
          ?  const SpinKitRing(color: Colors.brown)
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
            'companyPhoneNumber': employer!.companyPhoneNumber,
            'phoneNumber': employer!.phoneNumber,
            'email': employer!.email,
          }
              : {},
          child: Padding(
            padding:  const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (employer != null)
                  PhotoView(
                    photo: employer!.photo,
                    editable: true,
                    userId: employer!.id!
                  ),
                const SizedBox(height: 16),
                if (employer?.name != null) ...[
                   const Text(
                    'Podaci o firmi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTextField('name', 'Naziv firme'),
                  const SizedBox(height: 16),
                  _buildTextField('streetAddressAndNumber', 'Adresa i broj ulice'),
                  const SizedBox(height: 16),
                  FormBuilderDropdown<String>(
                    name: 'cityId',
                    decoration:  const InputDecoration(labelText: 'Sjedište firme'),
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
                _buildTextField('companyPhoneNumber', 'Službeni broj telefona', mask: phoneNumberMask),
                  _buildTextField(
                    'idNumber',
                    'ID broj',
                    mask: MaskTextInputFormatter(
                        mask: '4############',
                        filter: {'#': RegExp(r'[0-9]')}
                    ),
                  ),
                ],
                 const SizedBox(height: 16),
                if(employer?.name != null)
                 const Text(
                  'Odgovorno lice',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildTextField('firstName', 'Ime'),
                const SizedBox(height: 16),
                _buildTextField('lastName', 'Prezime'),
                if(employer?.name == null)...[
                  const SizedBox(height: 16),
                  FormBuilderDropdown<String>(
                    name: 'cityId',
                    decoration:  const InputDecoration(labelText: 'Sjedište firme'),
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
    ],
                const SizedBox(height: 16),
                _buildTextField('phoneNumber', 'Broj telefona', mask: phoneNumberMask),
                const SizedBox(height: 16),
                _buildTextField('email', 'Email', readOnly: true),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('Spasi promjene'),
                ),
              ],
            ),
          )



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
          return '$label je obavezno polje.';
        }
        return null;
      },
    );
  }
}
