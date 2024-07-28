import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/pages/employer/employer_info.dart';
import 'package:minijobs_mobile/pages/user-profile/active_jobs_view.dart';
import 'package:minijobs_mobile/pages/user-profile/finished_job_view.dart';
import 'package:minijobs_mobile/pages/user-profile/user_ratings_view.dart';

class EmployerProfilePage extends StatelessWidget {
  const EmployerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = int.parse( GetStorage().read('userId')) ;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: Column(
            children: [
              // Info section
              Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.grey[
                    200], // Optional background color for the info section
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile photo
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EmployerInfo(employerId: userId),
                          ),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile_photo.jpg'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Name
                    const Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Average rating
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        SizedBox(width: 5),
                        Text(
                          '4.5',
                          style: TextStyle(
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
