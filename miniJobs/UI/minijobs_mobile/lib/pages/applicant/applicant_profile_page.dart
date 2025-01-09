import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:provider/provider.dart';
import 'package:minijobs_mobile/pages/user-profile/finished_job_view.dart';
import 'package:minijobs_mobile/pages/user-profile/user_ratings_view.dart';

import '../../providers/authentication_provider.dart';
import '../../utils/photo_view.dart';
import '../user-profile/user_change_password.dart';
import 'applicant_info.dart';
import 'applicant_info_view.dart';

class ApplicantProfilePage extends StatefulWidget {
  final int userId;
  final bool showBackButton; // Add this parameter

  const ApplicantProfilePage({
    super.key,
    required this.userId,
    this.showBackButton = false, // Default to false if not provided
  });

  @override
  _ApplicantProfilePageState createState() => _ApplicantProfilePageState();
}

class _ApplicantProfilePageState extends State<ApplicantProfilePage> {
  late int userId;
  Applicant? applicant;
  bool isLoading = true;
  bool isAbleTodoEdit = false;
  late AuthenticationProvider _authenticationProvider;
  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    isAbleTodoEdit = userId == int.parse(GetStorage().read('userId'));
    _authenticationProvider = context.read<AuthenticationProvider>();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final applicantProvider = context.read<ApplicantProvider>();
      final fetchedUser = await applicantProvider.get(userId);
      setState(() {
        applicant = fetchedUser;
        isLoading = false;
      });
    } catch (error) {
      // Handle error
      setState(() {
        isLoading = false;
      });
    }
  }
  void  _handleLogout(BuildContext context)  {
    _authenticationProvider.logout(context);
  }
  void _handleChangePassword(BuildContext context)  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserChangePassword()),
    );
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: widget.showBackButton
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
                : null,
            title: const Text('Profile'),
            actions: isAbleTodoEdit
            ? [
              PopupMenuButton<String>(
                onSelected: (String value) {
                  if (value == 'logout') {
                    _handleLogout(context);
                  } else if (value == 'change_password') {
                    _handleChangePassword(context);
                  }
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(
                    value: 'change_password',
                    child: Text('Promijeni lozinku'),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Odjavi se'),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ]
                : null,
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              // Info section
              Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.grey[200], // Optional background color for the info section
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile photo and edit icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Center the row horizontally
                      children: [
                        const SizedBox(width: 35),

                        PhotoView(
                          photo: applicant?.photo,
                          editable: false,
                          userId: userId,
                        ),
                        if (isAbleTodoEdit)
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplicantInfo(applicantId: userId),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0), // Add space between PhotoView and icon
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue, // Blue color for the icon
                                size: 24.0, // Adjust icon size as needed
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Name
                    Text(
                      '${applicant?.firstName ?? ''} ${applicant?.lastName ?? ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Average rating
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        const SizedBox(width: 5),
                        Text(
                          applicant?.averageRating?.toStringAsFixed(1) ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Tabs section
              const TabBar(
                tabs: [
                  Tab(text: 'Info'),
                  Tab(text: 'Završeni'),
                  Tab(text: 'Utisci'),
                ],
              ),
              // Expanded tab bar view
              Expanded(
                child: TabBarView(
                  children: [
                    ApplicantInfoView(applicantId: userId),
                    FinishedJobsView(userId: userId),
                    UserRatingsView(userId: userId),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
