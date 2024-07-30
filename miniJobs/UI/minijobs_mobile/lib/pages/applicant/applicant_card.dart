import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant/applicant.dart';

import '../../utils/photo_view.dart';// Assuming you have a PhotoView widget in your project

class ApplicantCard extends StatelessWidget {
  final Applicant applicant;
  final bool showOptions;

  const ApplicantCard({super.key, required this.applicant, this.showOptions = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          child: ClipOval(
            child: PhotoView(
              photo: applicant.photo,
              editable: false,
              userId: applicant.id!
            ),
          ),
        ),
        title: Text('${applicant.firstName} ${applicant.lastName}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            if(applicant.numberOfFinishedJobs!=null && applicant.numberOfFinishedJobs!>0)
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
        trailing: showOptions
            ? IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showApplicantOptions(context, applicant);
          },
        )
            : null,
      ),
    );
  }

  void _showApplicantOptions(BuildContext context, Applicant applicant) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              onTap: () {
                // Handle email action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Call'),
              onTap: () {
                // Handle call action
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download CV'),
              onTap: () {
                // Handle download CV action
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
