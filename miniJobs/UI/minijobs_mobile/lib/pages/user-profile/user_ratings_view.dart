import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/models/rating.dart';
import 'package:minijobs_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UserRatingsView extends StatefulWidget {
  final int userId;
  const UserRatingsView({super.key,required this.userId});

  @override
  _UserRatingsViewState createState() => _UserRatingsViewState();
}
class _UserRatingsViewState extends State<UserRatingsView> {
  late UserProvider userProvider;
  List<Rating> ratings=[];
  @override
  void initState() {
    super.initState();
  }

@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    userProvider= context.read<UserProvider>();
    getRatings();
  }
      getRatings() async{
        ratings= await  userProvider.getUserRatings(widget.userId);
        setState(() {
          
        });
      }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Impressions'),
        ),
        body: ListView.builder(
          itemCount: ratings.length, // Replace this with your actual number of impressions
          itemBuilder: (context, index) {
            final rating= ratings[index];
            return  ImpressionCard(
              userPhoto: 'assets/user_photo.jpg', // Replace with actual user photo
              userName: rating.createdByFullName, // Replace with actual user name
              comment: rating.comment, // Replace with actual comment
              mark: rating.value, // Replace with actual mark
              date: rating.created, // Replace with actual date
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
  final DateTime date;

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
            Text(DateFormat('dd.MM.yyyy.').format(date)),
          ],
        ),
      ),
    );
  }
}