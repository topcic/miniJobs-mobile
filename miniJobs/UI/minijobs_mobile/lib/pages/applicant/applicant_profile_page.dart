import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:minijobs_mobile/providers/applicant_provider.dart';
import 'package:provider/provider.dart';
import 'package:minijobs_mobile/pages/user-profile/finished_job_view.dart';
import 'package:minijobs_mobile/pages/user-profile/user_ratings_view.dart';

import '../../utils/photo_view.dart';
import 'applicant_info.dart'; // Import your User model

class ApplicantProfilePage extends StatefulWidget {
  final int userId;
  const ApplicantProfilePage({super.key, required this.userId});

  @override
  _ApplicantProfilePageState createState() => _ApplicantProfilePageState();
}

class _ApplicantProfilePageState extends State<ApplicantProfilePage> {
  late int userId;
  Applicant? applicant;
  bool isLoading = true;
  bool isAbleTodoEdit=false;

  @override
  void initState() {
    super.initState();
    //userId = int.parse(GetStorage().read('userId'));
    userId=widget.userId;
    isAbleTodoEdit=userId==int.parse(GetStorage().read('userId'));
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
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
                              builder: (context) => ApplicantInfo(applicantId: userId),
                            ),
                          );
                        }
                      },
                      child: PhotoView(
                        photo: applicant?.photo,
                        editable: false,
                        userId: userId,
                      ),
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
                    // Aktivni poslovi tab
                  //  ActiveJobsView(userId: userId),
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
