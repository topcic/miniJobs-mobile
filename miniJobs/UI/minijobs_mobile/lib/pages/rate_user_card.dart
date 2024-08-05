import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../models/rating/rating_save_request.dart';
import '../models/user.dart';

class RateUserCard extends StatefulWidget {
  final int ratedUserId;
  final int jobApplicationId;

  const RateUserCard({super.key, required this.ratedUserId, required this.jobApplicationId});

  @override
  _RateUserCardState createState() => _RateUserCardState();
}

class _RateUserCardState extends State<RateUserCard> {
  final _formKey = GlobalKey<FormState>();
  late UserProvider userProvider;
  User? ratedUser;
  double rating = 0;
  String comment = '';
  bool isLoading = false;
  String? ratingError;
  String? commentError;

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
          : Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Koliko ste zadovoljni sa poslovanjem sa korisnikom?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ratingError != null ? Colors.red : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(4),
                color: ratingError != null ? Colors.red.withOpacity(0.1) : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          rating = index + 1.0;
                          ratingError = null; // Clear the error when a rating is selected
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: rating == index + 1.0 ? Colors.blue : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: rating == index + 1.0 ? Colors.blue.withOpacity(0.2) : Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: rating == index + 1.0 ? Colors.blue : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            if (ratingError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  ratingError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 16.0),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Komentar',
                border: OutlineInputBorder(),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              onChanged: (value) {
                comment = value;
                commentError = null; // Clear the error when a comment is entered
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Komentar je obavezan';
                }
                return null;
              },
            ),
            if (commentError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  commentError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
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
            if (_formKey.currentState?.validate() == true && rating > 0) {
              setState(() {
                isLoading = true;
                ratingError = null; // Clear the error when validation passes
              });
              _submitRating();
            } else {
              setState(() {
                if (rating == 0) {
                  ratingError = 'Ocjena je obavezna';
                }
              });
            }
          },
        ),
      ],
      contentPadding: EdgeInsets.only(top: 20, left: 24, right: 24, bottom: isLoading ? 24 : 0),
    );
  }

  Future<void> _submitRating() async {
    if (ratedUser != null) {
      final ratingSaveRequest = RatingSaveRequest(
        comment,
        rating.toInt(),
        widget.jobApplicationId,
        ratedUser!.id!,
      );

      // Return the RatingSaveRequest object to the calling component
      Navigator.of(context).pop(ratingSaveRequest);
    }
  }
}
