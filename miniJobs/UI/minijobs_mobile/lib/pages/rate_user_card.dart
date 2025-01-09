
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../models/rating/rating_save_request.dart';
import '../models/user/user.dart';
import '../providers/rating_provider.dart';

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
  late RatingProvider ratingProvider;
  late Future<User?> ratedUserFuture;
  double rating = 0;
  String comment = '';
  bool isLoading = false;
  String? ratingError;
  String? commentError;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userProvider = context.read<UserProvider>();
    ratingProvider = context.read<RatingProvider>();

    ratedUserFuture = userProvider.get(widget.ratedUserId);
  }

  Future<void> rate() async {
    final request = RatingSaveRequest(
        comment,
        rating.toInt(),
        widget.jobApplicationId
    );

    ratingProvider.insert(request).then((response) {
      Navigator.of(context).pop(request);
    });
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: ratedUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text('Failed to load user data.'));
        }

        final ratedUser = snapshot.data;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey, // Attach the GlobalKey to the Form
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      'Ocijenite ${ratedUser!.fullName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Question
                    const Text(
                      'Koliko ste zadovoljni sa poslovanjem sa korisnikom?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Rating stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              rating = index + 1.0;
                              ratingError = null; // Clear the error when a rating is selected
                            });
                          },
                          child: Icon(
                            Icons.star,
                            color: rating >= index + 1 ? Colors.blue : Colors.grey,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    if (ratingError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          ratingError!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Comment field
                    TextFormField(
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Komentar',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                      onChanged: (value) {
                        comment = value;
                        setState(() {
                          commentError = null; // Clear the error when a comment is entered
                        });
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
                    const SizedBox(height: 16),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text('Odustani'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState?.validate() == true && rating > 0) {
                              setState(() {
                                isLoading = true;
                                ratingError = null; // Clear the error when validation passes
                              });
                              await rate();
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                if (rating == 0) {
                                  ratingError = 'Ocjena je obavezna';
                                }
                              });
                            }
                          },
                          child: isLoading
                              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                              : const Text('Ocijeni'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      },
    );
  }
}