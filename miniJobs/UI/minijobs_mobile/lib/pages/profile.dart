import 'package:flutter/material.dart';
import 'package:minijobs_mobile/pages/impressions.dart';
import 'package:minijobs_mobile/pages/user-profile/finished_job_view.dart';
import 'package:minijobs_mobile/pages/user-profile/user_ratings_view.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Info'),
                Tab(text: 'Završeni poslovi'),
                Tab(text: 'Utisci'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              // Info tab
              Container(
                padding: const EdgeInsets.all(20.0),
                alignment: Alignment.center,
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
              // Završeni poslovi tab
              const Center(
                child: FinishedJobsView(userId: 2),
              ),
              // Utisci tab
              const Center(
                child: UserRatingsView(userId: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}