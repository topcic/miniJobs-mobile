import 'package:flutter/material.dart';

class ImpressionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Impressions'),
        ),
        body: ListView.builder(
          itemCount: 5, // Replace this with your actual number of impressions
          itemBuilder: (context, index) {
            return ImpressionCard(
              userPhoto: 'assets/user_photo.jpg', // Replace with actual user photo
              userName: 'John Doe', // Replace with actual user name
              comment: 'Great work!', // Replace with actual comment
              mark: 5, // Replace with actual mark
              date: 'April 1, 2024', // Replace with actual date
            );
          },
        ),
      ),
    );
  }
}

class ImpressionCard extends StatelessWidget {
  final String userPhoto;
  final String userName;
  final String comment;
  final int mark;
  final String date;

  const ImpressionCard({
    Key? key,
    required this.userPhoto,
    required this.userName,
    required this.comment,
    required this.mark,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(userPhoto),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(comment),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.star, color: Colors.yellow),
                SizedBox(width: 5),
                Text(mark.toString()),
              ],
            ),
            SizedBox(height: 5),
            Text(date),
          ],
        ),
      ),
    );
  }
}