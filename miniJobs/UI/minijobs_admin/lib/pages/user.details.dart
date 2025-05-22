import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import 'main/constants.dart';
import 'main/responsve.dart';

class UserDetailsPage extends StatefulWidget {
  final int userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late UserProvider _userProvider;
  User? user;
  final _formKey = GlobalKey<FormBuilderState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  bool isLoading = true;
  String? errorMessage;
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneNumberError;
  final maskFormatter = MaskTextInputFormatter(
    mask: '+387 ## #######',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager, // Allow partial input
  );

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = context.read<UserProvider>();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final data = await _userProvider.get(widget.userId);
      if (mounted) {
        setState(() {
          user = data;
          isLoading = false;
          _firstNameController.text = user?.firstName ?? '';
          _lastNameController.text = user?.lastName ?? '';
          _phoneNumberController.text = user?.phoneNumber ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Neuspješno učitavanje podataka: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Neuspješno učitavanje podataka: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveUserDetails() async {
    setState(() {
      _firstNameError = null;
      _lastNameError = null;
      _phoneNumberError = null;
    });

    if (_formKey.currentState!.saveAndValidate()) {
      try {
        // Assuming _userProvider.update exists to save the updated user details
        await _userProvider.update(widget.userId, {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phoneNumber': _phoneNumberController.text,
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Podaci uspješno ažurirani')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Neuspješno ažuriranje podataka: $e')),
          );
        }
      }
    } else {
      setState(() {
        if (_formKey.currentState!.fields['firstName']!.hasError) {
          _firstNameError = 'Ime je obavezno polje';
        }
        if (_formKey.currentState!.fields['lastName']!.hasError) {
          _lastNameError = 'Prezime je obavezno polje';
        }
        if (_formKey.currentState!.fields['phoneNumber']!.hasError) {
          _phoneNumberError = 'Broj telefona je nevalidan';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          user != null ? '${user!.firstName} ${user!.lastName}' : 'Detalji računa',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, MediaQuery.of(context).size.width),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          user != null ? '${user!.firstName} ${user!.lastName}' : 'Detalji računa',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _buildBody(context, MediaQuery.of(context).size.width),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          user != null ? '${user!.firstName} ${user!.lastName}' : 'Detalji računa',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: _buildBody(context, MediaQuery.of(context).size.width),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double width) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: primaryColor));
    }
    if (errorMessage != null || user == null) {
      return Center(
        child: Text(
          errorMessage ?? 'Neuspješno učitavanje podataka',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
    return _buildForm(context, width);
  }

  Widget _buildForm(BuildContext context, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: width,
            child: FormBuilder(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Detalji računa',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'firstName',
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Ime',
                      labelStyle: const TextStyle(fontSize: 14),
                      border: const OutlineInputBorder(),
                      errorText: _firstNameError,
                    ),
                    style: const TextStyle(fontSize: 12),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ime je obavezno polje';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'lastName',
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Prezime',
                      labelStyle: const TextStyle(fontSize: 14),
                      border: const OutlineInputBorder(),
                      errorText: _lastNameError,
                    ),
                    style: const TextStyle(fontSize: 12),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Prezime je obavezno polje';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    inputFormatters: [maskFormatter],
                    name: 'phoneNumber',
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Broj telefona',
                      labelStyle: const TextStyle(fontSize: 14),
                      border: const OutlineInputBorder(),
                      errorText: _phoneNumberError,
                    ),
                    style: const TextStyle(fontSize: 12),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value != null && value.isNotEmpty && !maskFormatter.isFill()) {
                        return 'Nevalidan format broja telefona';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  FormBuilderTextField(
                    name: 'email',
                    initialValue: user?.email ?? '',
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 14),
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 12),
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email je obavezno polje';
                      }
                      if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Nevalidan format';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _saveUserDetails,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Sačuvaj promjene',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}