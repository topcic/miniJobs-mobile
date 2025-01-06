import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/employer/employer.dart';
import 'package:provider/provider.dart';
import 'package:minijobs_mobile/pages/employer/employer_info.dart';
import 'package:minijobs_mobile/pages/user-profile/active_jobs_view.dart';
import 'package:minijobs_mobile/pages/user-profile/finished_job_view.dart';
import 'package:minijobs_mobile/pages/user-profile/user_ratings_view.dart';

import '../../providers/authentication_provider.dart';
import '../../providers/employer_provider.dart';
import '../../utils/photo_view.dart';

class EmployerProfilePage extends StatefulWidget {
  final int userId;
  const EmployerProfilePage({super.key, required this.userId});

  @override
  _EmployerProfilePageState createState() => _EmployerProfilePageState();
}

class _EmployerProfilePageState extends State<EmployerProfilePage> {
  late int userId;
  Employer? employer;
  bool isLoading = true;
  bool isAbleTodoEdit=false;
  late AuthenticationProvider _authenticationProvider;

  @override
  void initState() {
    super.initState();
    userId=widget.userId;
    isAbleTodoEdit=userId==int.parse(GetStorage().read('userId'));
    _authenticationProvider = context.read<AuthenticationProvider>();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final employerProvider = context.read<EmployerProvider>();
      final fetchedUser = await employerProvider.get(userId);
      setState(() {
        employer = fetchedUser;
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: isAbleTodoEdit
                ? [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Odjavi se',
                onPressed: () {
                  _handleLogout(context);
                },
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
                    // Profile photo
                    GestureDetector(
                      onTap: () {
                        if(isAbleTodoEdit) {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmployerInfo(employerId: userId),
                          ),
                        );
                        }
                      },
                      child: PhotoView(
                        photo: employer?.photo,
                        editable: false,
                        userId: userId,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Name
                    Text(
                      employer?.name ?? '${employer?.firstName ?? ''} ${employer?.lastName ?? ''}',
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
                          employer?.averageRating?.toStringAsFixed(1) ?? 'N/A',
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
                  Tab(text: 'Aktivni'),
                  Tab(text: 'Završeni'),
                  Tab(text: 'Utisci'),
                ],
              ),
              // Expanded tab bar view
              Expanded(
                child: TabBarView(
                  children: [
                    // Aktivni poslovi tab
                    ActiveJobsView(userId: userId),
                    // Završeni poslovi tab
                    FinishedJobsView(userId: userId),
                    // Utisci tab
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
