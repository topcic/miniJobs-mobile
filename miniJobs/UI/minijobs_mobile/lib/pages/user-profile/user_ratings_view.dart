import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/models/rating.dart';
import 'package:minijobs_mobile/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/photo_view.dart';

class UserRatingsView extends StatefulWidget {
  final int userId;
  const UserRatingsView({super.key, required this.userId});

  @override
  _UserRatingsViewState createState() => _UserRatingsViewState();
}

class _UserRatingsViewState extends State<UserRatingsView> {
  late UserProvider userProvider;
  List<Rating> ratings = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    getRatings();
  }

  getRatings() async {
    ratings = await userProvider.getUserRatings(widget.userId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (ratings.isEmpty) {
      return const Center(
        child: Text(
          'Korisnik nije bio ocjenjen',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView.builder(
          itemCount: ratings.length,
          itemBuilder: (context, index) {
            final rating = ratings[index];
            return ImpressionCard(
                rating: rating,
            );
          },
        ),
      ),
    );
  }
}

class ImpressionCard extends StatelessWidget {
  final Rating rating;

  const ImpressionCard({
    super.key,
    required this.rating
  });

  @override
  Widget build(BuildContext context) {

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          child: PhotoView(
              photo: rating.photo,
              editable: false,
              userId: rating.createdBy!
            ),
          ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              rating.createdByFullName!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(rating.comment),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.yellow),
                const SizedBox(width: 5),
                Text(rating.value .toString()),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              DateFormat('dd.MM.yyyy.').format(rating.created!),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
