import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/photo_view.dart';
import '../../enumerations/job_application_status.dart';
import '../../enumerations/job_statuses.dart';
import '../../models/rating/rating_save_request.dart';
import '../../models/applicant/applicant.dart';
import '../../providers/job_application_provider.dart';
import '../../widgets/badges.dart';
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
  final bool _isLoading = false;
  late JobApplicationProvider jobApplicationProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobApplicationProvider = context.read<JobApplicationProvider>();
  }

  Future<void> _handleAccept(bool accept) async {
    final response = await jobApplicationProvider.accept(
        widget.jobId!, widget.applicant.jobApplicationId!, accept);

    if (response != null) {
      setState(() {
        widget.applicant.applicationStatus = accept
            ? JobApplicationStatus.Prihvaceno
            : JobApplicationStatus.Odbijeno;
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
      setState(() {
        widget.applicant.isRated = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRated = widget.applicant.isRated ?? false;

    return Stack(
      children: [
        InkWell(
          onTap: () {
            // Navigate to ApplicantProfilePage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApplicantProfilePage(
                  userId: widget.applicant.id!,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12), // Add ripple effect
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
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
                      // Applicant Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.applicant.firstName} ${widget.applicant.lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text(
                                  widget.applicant.city?.name ?? 'No City',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            if (widget.applicant.numberOfFinishedJobs != null &&
                                widget.applicant.numberOfFinishedJobs! > 0)
                              Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, size: 14, color: Colors.green), // Better icon for "completed jobs"
                                    const SizedBox(width: 4),
                                    Text(
                                      '${widget.applicant.numberOfFinishedJobs} poslova', // Add "jobs" for clarity
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (widget.applicant.applicationStatus != null &&
                          widget.jobStatus != null &&
                          widget.jobId != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: JobApplicationBadge(
                            status: widget.applicant.applicationStatus!,
                          ),
                        ),
                    ],
                  ),
                  const Divider(height: 24),
                  if (widget.jobStatus == JobStatus.AplikacijeZavrsene &&
                      widget.applicant.applicationStatus ==
                          JobApplicationStatus.Poslano)
                    _buildApplicationStatusButtons(),
                  if (widget.jobStatus == JobStatus.Zavrsen &&
                      widget.applicant.applicationStatus ==
                          JobApplicationStatus
                              .Prihvaceno) //widget.showChooseButton
                    Align(
                      alignment: Alignment.centerRight,
                      child: isRated
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
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
                              child: const Text('Ocjeni'),
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
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _buildApplicationStatusButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end, // Align buttons to the right
      children: [
        ElevatedButton.icon(
          onPressed: () => _handleAccept(false),
          icon: const Icon(Icons.close, size: 14, color: Colors.white),
          // White icon, smaller size
          label: const Text(
            'Odbij',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white), // White text, smaller font size
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[700],
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            // Reduced padding
            minimumSize: const Size(90, 32), // Smaller button dimensions
          ),
        ),
        const SizedBox(width: 6), // Adjust spacing between buttons
        ElevatedButton.icon(
          onPressed: () => _handleAccept(true),
          icon: const Icon(Icons.check, size: 14, color: Colors.white),
          // White icon, smaller size
          label: const Text(
            'Odobri',
            style: TextStyle(
                fontSize: 12,
                color: Colors.white), // White text, smaller font size
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            // Reduced padding
            minimumSize: const Size(90, 32), // Smaller button dimensions
          ),
        ),
      ],
    );
  }
}
