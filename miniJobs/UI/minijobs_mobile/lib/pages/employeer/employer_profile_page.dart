import 'package:flutter/material.dart';
import 'package:minijobs_mobile/pages/user-profile/active_jobs_view.dart';
import 'package:minijobs_mobile/pages/user-profile/finished_job_view.dart';
import 'package:minijobs_mobile/pages/user-profile/user_ratings_view.dart';

class EmployerProfilePage extends StatelessWidget {
  const EmployerProfilePage({super.key});

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
          body: Column(
            children: [
              // Info section
              Container(
                padding: const EdgeInsets.all(20.0),
                color: Colors.grey[200], // Optional background color for the info section
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile photo
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/profile_photo.jpg'),
                    ),
                    SizedBox(height: 10),
                    // Name
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    // Average rating
                    Row(
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
                    ActiveJobsView(userId: 2),
                    // Završeni poslovi tab
                    FinishedJobsView(userId: 2),
                    // Utisci tab
                    UserRatingsView(userId: 2),
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
