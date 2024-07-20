import 'package:flutter/material.dart';

class ImpressionsPage extends StatelessWidget {
  const ImpressionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Impressions'),
        ),
        body: ListView.builder(
          itemCount: 5, // Replace this with your actual number of impressions
          itemBuilder: (context, index) {
            return const ImpressionCard(
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
    super.key,
    required this.userPhoto,
    required this.userName,
    required this.comment,
    required this.mark,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(comment),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 5),
                Text(mark.toString()),
              ],
            ),
            const SizedBox(height: 5),
            Text(date),
          ],
        ),
      ),
    );
  }
}