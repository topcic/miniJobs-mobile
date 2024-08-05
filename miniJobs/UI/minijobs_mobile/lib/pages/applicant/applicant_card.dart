import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';
import 'package:provider/provider.dart';
import '../../../utils/photo_view.dart';
import '../../models/rating/rating_save_request.dart';
import '../rate_user_card.dart';
import '../../providers/rating_provider.dart';
import 'applicant_profile_page.dart';

class ApplicantCard extends StatefulWidget {
  final Applicant applicant;
  final bool showChooseButton;

  const ApplicantCard({
    super.key,
    required this.applicant,
    this.showChooseButton = false,
  });

  @override
  _ApplicantCardState createState() => _ApplicantCardState();
}

class _ApplicantCardState extends State<ApplicantCard> {
  bool _isLoading = false;

  Future<void> _handleRating(BuildContext context) async {
    final ratingSaveRequest = await showDialog<RatingSaveRequest>(
      context: context,
      builder: (BuildContext context) {
        return RateUserCard(
          ratedUserId: widget.applicant.id!,
          jobApplicationId: widget.applicant.jobApplicationId!,
        );
      },
    );

    if (ratingSaveRequest != null) {
      final ratingProvider = Provider.of<RatingProvider>(context, listen: false);

      setState(() {
        _isLoading = true; // Start loading
      });

      try {
        final success = await ratingProvider.insert(ratingSaveRequest);

        setState(() {
          widget.applicant.isRated = true; // Start loading
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Uspješno ste ocijenili korisnika.')),
        );
            } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Došlo je do greške: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isRated = widget.applicant.isRated ?? false; // Assuming isRated is a property in Applicant

    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApplicantProfilePage(userId: widget.applicant.id!,showBackButton: true),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    child: ClipOval(
                      child: PhotoView(
                        photo: widget.applicant.photo,
                        editable: false,
                        userId: widget.applicant.id!,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.applicant.firstName} ${widget.applicant.lastName}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              widget.applicant.city?.name ?? 'No City',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (widget.applicant.numberOfFinishedJobs != null &&
                            widget.applicant.numberOfFinishedJobs! > 0)
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Text(
                              '${widget.applicant.numberOfFinishedJobs}', // Replace with actual completed jobs count
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                  if (widget.showChooseButton)
                    Align(
                      alignment: Alignment.centerRight,
                      child: isRated
                          ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Ocijenjen',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: () => _handleRating(context),
                        child: const Text('Izaberi'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}
