import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/applicant.dart';

class ApplicantCard extends StatelessWidget {
  final Applicant applicant;

  const ApplicantCard({super.key, required this.applicant});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundImage: applicant.photo != null
              ? MemoryImage(applicant.photo!)
              : const AssetImage('assets/images/default_user.png') as ImageProvider,
          radius: 30,
        ),
        title: Text('${applicant.firstName} ${applicant.lastName}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(applicant.city?.name ?? 'No City',
                    style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blue,
              child: Text(
                '10', // Replace with actual completed jobs count
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showApplicantOptions(context, applicant);
          },
        ),
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
