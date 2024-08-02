import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../models/user.dart';

class RateUserCard extends StatefulWidget {
  final int ratedUserId;

  const RateUserCard({Key? key, required this.ratedUserId}) : super(key: key);

  @override
  _RateUserCardState createState() => _RateUserCardState();
}

class _RateUserCardState extends State<RateUserCard> {
  late UserProvider userProvider;
  User? ratedUser;
  double rating = 0.0;
  String comment = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    ratedUser = await userProvider.get(widget.ratedUserId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: ratedUser == null
          ? const Text('Loading...')
          : Text('Ocijenite ${ratedUser!.fullName}'),
      content: ratedUser == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Koliko ste zadovoljni sa poslovanjem sa korisnikom?',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      rating = index + 1.0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: rating == index + 1.0
                            ? Colors.blue
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: rating == index + 1.0
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: rating == index + 1.0
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Komentar',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              comment = value;
            },
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Odustani'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: const Text('Ocijeni'),
          onPressed: () {
            // Handle the rating and comment submission here
            _submitRating();
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }

  void _submitRating() {
    if (ratedUser != null) {
      // Submit rating and comment logic
      // For example, call a method in the UserProvider to save the rating
    //  userProvider.submitRating(
     //   ratedUserId: ratedUser!.id,
      //  rating: rating.toInt(),
//comment: comment,
   //   );
    }
  }
}
