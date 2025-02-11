import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/enumerations/job_application_status.dart';
import 'package:minijobs_mobile/pages/employer/job/job_modal.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/widgets/badges.dart';
import 'package:provider/provider.dart';

import '../../../enumerations/job_statuses.dart';
import '../../../models/job/job_application.dart';
import '../../../models/rating/rating_save_request.dart';
import '../../../services/notification.service.dart';
import '../../rate_user_card.dart';

class JobApplicationCard extends StatefulWidget {
  final JobApplication jobApplication;
  final bool isInAppliedJobs;
  const JobApplicationCard({super.key, required this.jobApplication,this.isInAppliedJobs = false});

  @override
  State<JobApplicationCard> createState() => _JobApplicationCardState();
}

class _JobApplicationCardState extends State<JobApplicationCard> {
  final notificationService = NotificationService();
  late JobProvider jobProvider;
  late JobApplication jobApplication;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobProvider = context.read<JobProvider>();
    jobApplication = widget.jobApplication;
  }
  bool canUserRate() {
    return jobApplication.job!.status == JobStatus.Zavrsen &&
        !jobApplication.hasRated &&
        jobApplication.status == JobApplicationStatus.Prihvaceno ;
  }
  Future<void> _handleRating(BuildContext context) async {
    final ratingSaveRequest = await showDialog<RatingSaveRequest>(
      context: context,
      builder: (BuildContext context) {
        return RateUserCard(
          jobApplicationId: jobApplication.id!,
          ratedUserId: jobApplication.job!.createdBy!,
        );
      },
    );

    if (ratingSaveRequest != null) {
      setState(() {
        jobApplication.hasRated = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final createdDate = DateFormat('dd.MM.yyyy.').format(jobApplication.created!);

    return Card(
      margin: const EdgeInsets.all(12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.blue[50],
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           if( canUserRate())
            Row(

        mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            const Spacer(),
              InkWell(
                    onTap: () {
                      _handleRating(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.star_border,
                        color: Colors.amber,
                        size: 28,
                      ),
                    ),
                ),
              ],
            ),

            // Job Name
            Text(
              jobApplication.job!.name!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 12),

            // Location
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                Text(
                  jobApplication.job!.city!.name!,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Wage
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.money_sharp, size: 16, color: Colors.green),
                Text(
                  jobApplication.job!.wage != null && jobApplication.job!.wage! > 0
                      ? '${jobApplication.job!.wage} KM'
                      : 'po dogovoru',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.green[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Application Created Date
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                Text(
                  'Prijavljen: $createdDate',
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Job Application Badge
            JobApplicationBadge(status: jobApplication.status!),
            const SizedBox(height: 16),

            // View Details Button
            ElevatedButton(
              onPressed: () async {
                if (jobApplication.job!.id != null) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return JobModal(
                        jobId: jobApplication.job!.id!,
                        role: GetStorage().read('role'),
                        isInAppliedJobs: widget.isInAppliedJobs
                      );
                    },
                  );
                } else {
                  notificationService.success('Detalji posla nisu dostupni');
                }
              },
              child: const Text('Pogledaj', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}