import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:provider/provider.dart';
import 'package:minijobs_mobile/pages/user-profile/finished_job_view.dart';
import 'package:minijobs_mobile/pages/user-profile/user_ratings_view.dart';
import 'dart:typed_data';
import '../../providers/authentication_provider.dart';
import '../../utils/photo_view.dart';
import '../user-profile/user_change_password.dart';
import 'applicant_info.dart';
import 'applicant_info_view.dart';

class ApplicantProfilePage extends StatefulWidget {
  final int userId;

  const ApplicantProfilePage({
    super.key,
    required this.userId,
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
  final GlobalKey<ApplicantInfoViewState> _applicantInfoViewKey = GlobalKey();

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
      _updatePhoto(fetchedUser.photo);
      setState(() {
        applicant = fetchedUser;
        isLoading = false;
      });
      _applicantInfoViewKey.currentState?.refresh();
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleLogout(BuildContext context) {
    _authenticationProvider.logout(context);
  }

  void _handleChangePassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const UserChangePassword()),
    );
  }

  void _updatePhoto(Uint8List? newPhoto) {
    setState(() {
      if (newPhoto != null) {
        applicant?.photo = Uint8List.fromList(newPhoto);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check the role from GetStorage
    final String? role = GetStorage().read('role');
    final bool showBackButton = role != 'Applicant'; // Show back button only if role is not 'Applicant'

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: showBackButton // Conditionally show back button
                ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop(); // Navigate back to previous screen
              },
            )
                : null, // No back button if role is 'Applicant'
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
              Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 35),
                        PhotoView(
                          key: ValueKey(applicant?.photo?.hashCode),
                          photo: applicant?.photo,
                          editable: false,
                          userId: userId,
                        ),
                        if (isAbleTodoEdit)
                          GestureDetector(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplicantInfo(
                                    applicantId: userId,
                                    onBack: () => fetchUserData(),
                                  ),
                                ),
                              );
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.edit,
                                color: Colors.blue,
                                size: 24.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${applicant?.firstName ?? ''} ${applicant?.lastName ?? ''}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          applicant?.city?.name ?? 'No City',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16), // Match color with other views
                        const SizedBox(width: 5),
                        Text(
                          applicant?.averageRating != null
                              ? '${applicant!.averageRating!.toStringAsFixed(1)}' // Add scale
                              : 'N/A',
                          style: const TextStyle(
                            fontSize: 14, // Slightly smaller for balance
                            color: Colors.black, // Consistent color
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: 'Info'),
                  Tab(text: 'Završeni'),
                  Tab(text: 'Utisci'),
                ],
              ),
              Expanded(
                child: KeyedSubtree(
                  key: ValueKey(applicant?.hashCode),
                  child: TabBarView(
                    children: [
                      ApplicantInfoView(
                        key: _applicantInfoViewKey,
                        applicantId: userId,
                      ),
                      FinishedJobsView(userId: userId),
                      UserRatingsView(userId: userId),
                    ],
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