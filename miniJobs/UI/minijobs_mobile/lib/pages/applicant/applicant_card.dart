import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/photo_view.dart';
import '../../enumerations/job_application_status.dart';
import '../../enumerations/job_statuses.dart';
import '../../models/rating/rating_save_request.dart';
import '../../providers/rating_provider.dart';
import '../../models/applicant/applicant.dart';
import '../../providers/job_application_provider.dart';
import '../rate_user_card.dart';
import 'applicant_profile_page.dart';

class ApplicantCard extends StatefulWidget {
  final Applicant applicant;
  final JobStatus? jobStatus;
  final int? jobId;

  const ApplicantCard({
    super.key,
    required this.applicant,
    this.jobStatus,
    this.jobId,
  });

  @override
  _ApplicantCardState createState() => _ApplicantCardState();
}

class _ApplicantCardState extends State<ApplicantCard> {
  bool _isLoading = false;
  late JobApplicationProvider jobApplicationProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobApplicationProvider = context.read<JobApplicationProvider>();
  }

  Future<void> _handleAccept(bool accept) async {
    final response = await jobApplicationProvider.accept(widget.jobId!,widget.applicant.jobApplicationId!, accept);

    if (response != null) {
      setState(() {
        widget.applicant.applicationStatus =
        accept ? JobApplicationStatus.Prihvaceno : JobApplicationStatus.Odbijeno;
      });
    }
  }

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
        _isLoading = true;
      });

      try {
        final success = await ratingProvider.insert(ratingSaveRequest);

        setState(() {
          widget.applicant.isRated = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully rated the applicant.')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRated = widget.applicant.isRated ?? false;

    return Stack(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
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
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                          if (widget.applicant.numberOfFinishedJobs != null &&
                              widget.applicant.numberOfFinishedJobs! > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, size: 16, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${widget.applicant.numberOfFinishedJobs} jobs completed',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget.jobStatus == JobStatus.Zavrsen &&
                        widget.applicant.applicationStatus ==
                            JobApplicationStatus.Prihvaceno)
                      _buildRatingButton(isRated),
                  ],
                ),
                const Divider(height: 24),
                if (widget.jobStatus == JobStatus.AplikacijeZavrsene)
                  _buildApplicationStatusButtons(),
              ],
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingButton(bool isRated) {
    return ElevatedButton(
      onPressed: isRated ? null : () => _handleRating(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: isRated ? Colors.green : Colors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(isRated ? 'Rated' : 'Rate'),
    );
  }

  Widget _buildApplicationStatusButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () => _handleAccept(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Accept'),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => _handleAccept(false),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Reject'),
        ),
      ],
    );
  }
}
