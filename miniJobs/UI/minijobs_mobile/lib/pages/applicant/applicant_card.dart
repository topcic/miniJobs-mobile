import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';

import '../../../utils/photo_view.dart';
import '../rate_user_card.dart';

class ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  final bool showChooseButton;

  const ApplicantCard({
    super.key,
    required this.applicant,
    this.showChooseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  photo: applicant.photo,
                  editable: false,
                  userId: applicant.id!,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${applicant.firstName} ${applicant.lastName}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        applicant.city?.name ?? 'No City',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (applicant.numberOfFinishedJobs != null &&
                      applicant.numberOfFinishedJobs! > 0)
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${applicant.numberOfFinishedJobs}', // Replace with actual completed jobs count
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
            if (showChooseButton)
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return RateUserCard(ratedUserId: applicant.id!);
                      },
                    );
                  },
                  child: const Text('Izaberi'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
