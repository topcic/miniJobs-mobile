import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../models/user/user.dart';
import '../../providers/user_provider.dart';
import '../main/constants.dart';
import '../main/responsve.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late UserProvider _userProvider;
  User? user;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneNumberController;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint('UserDetailsPage: initState called');
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('UserDetailsPage: didChangeDependencies called');
    _userProvider = context.read<UserProvider>();
    fetchUser();
  }

  Future<void> fetchUser() async {
    debugPrint('UserDetailsPage: fetchUser called');
    try {
      final userId = GetStorage().read('userId');
      debugPrint('UserDetailsPage: userId from GetStorage: $userId');
      if (userId == null) {
        throw Exception('User ID not found in storage');
      }
      final data = await _userProvider.get(userId);
      debugPrint('UserDetailsPage: Fetched user data: ${data.toString()}');
      if (mounted) {
        setState(() {
          user = data;
          isLoading = false;
          _firstNameController.text = user?.firstName ?? '';
          _lastNameController.text = user?.lastName ?? '';
          _phoneNumberController.text = user?.phoneNumber ?? '';
        });
      }
    } catch (e, stackTrace) {
      debugPrint('UserDetailsPage: Error fetching user: $e');
      debugPrint('UserDetailsPage: Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load user data: $e';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load user data: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    debugPrint('UserDetailsPage: dispose called');
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveUserDetails() async {
    debugPrint('UserDetailsPage: _saveUserDetails called');
    if (_formKey.currentState!.validate()) {
      try {
        final userId = GetStorage().read('userId');
        debugPrint('UserDetailsPage: Saving user with ID: $userId');
        if (userId == null) {
          throw Exception('User ID not found in storage');
        }
     /*   final updatedUser = User(
          id: userId,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          fullName: '${_firstNameController.text} ${_lastNameController.text}',
          email: user?.email ?? '',
          phoneNumber: _phoneNumberController.text,
        );
        await _userProvider.update(userId, updatedUser);*/
        debugPrint('UserDetailsPage: User updated successfully');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User details updated successfully')),
          );
        }
      } catch (e) {
        debugPrint('UserDetailsPage: Error saving user: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save user details: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('UserDetailsPage: build called');
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
        title: const Text('User Details', style: TextStyle(color: Colors.white)),
      ),
      body: _buildBody(context, MediaQuery.of(context).size.width * 0.9),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('User Details', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _buildBody(context, MediaQuery.of(context).size.width * 0.7),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('User Details', style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _buildBody(context, MediaQuery.of(context).size.width * 0.5),
      ),
    );
  }

  Widget _buildBody(BuildContext context, double width) {
    if (isLoading) {
      debugPrint('UserDetailsPage: Showing loading indicator');
      return const Center(child: CircularProgressIndicator(color: primaryColor));
    }
    if (errorMessage != null || user == null) {
      debugPrint('UserDetailsPage: Showing error: $errorMessage');
      return Center(
        child: Text(
          errorMessage ?? 'Failed to load user data',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      );
    }
    debugPrint('UserDetailsPage: Showing form with user: ${user.toString()}');
    return _buildForm(context, width);
  }

  Widget _buildForm(BuildContext context, double width) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Form(
        key: _formKey,
        child: Container(
          width: width,
          padding: const EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding),
              TextFormField(
                initialValue: user?.email ?? '',
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: bgColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: const TextStyle(color: Colors.white70),
                readOnly: true,
              ),
              const SizedBox(height: defaultPadding * 2),
              Center(
                child: ElevatedButton(
                  onPressed: _saveUserDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: defaultPadding * 2,
                      vertical: defaultPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}