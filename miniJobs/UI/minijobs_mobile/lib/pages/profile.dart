import 'package:flutter/material.dart';
import 'package:minijobs_mobile/pages/impressions.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            bottom: TabBar(
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
                padding: EdgeInsets.all(20.0),
                alignment: Alignment.center,
                child: Column(
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
              Center(
                child: Text('Završeni poslovi'),
              ),
              // Utisci tab
              Center(
                child: ImpressionsPage(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}