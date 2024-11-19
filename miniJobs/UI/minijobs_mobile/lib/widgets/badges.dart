import 'package:flutter/material.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';

import '../enumerations/job_application_status.dart';

// Default Badge Widget
class Badge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const Badge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: backgroundColor,
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// User Badge Widget extending Badge
class UserBadge extends StatelessWidget {
  final String status;

  const UserBadge({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[200]!;
    Color textColor = Colors.grey[800]!;

    // Customize appearance based on status
    if (status == 'Obrisan') {
      backgroundColor = Colors.redAccent[100]!;
      textColor = Colors.redAccent[700]!;
    } else if (status == 'Aktivan') {
      backgroundColor = Colors.greenAccent[100]!;
      textColor = Colors.greenAccent[700]!;
    }

    return Badge(
      text: status,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}

class JobBadge extends StatelessWidget {
  final JobStatus status;

  const JobBadge({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color backgroundColor;
    Color textColor = Colors.white;

    // Customize appearance based on status
    switch (status) {
      case JobStatus.Kreiran:
        statusText = 'Kreiran';
        backgroundColor = Colors.blue[400]!;
        break;
      case JobStatus.Aktivan:
        statusText = 'Aktivan';
        backgroundColor = Colors.green[400]!;
        break;
      case JobStatus.Zavrsen:
        statusText = 'Završen';
        backgroundColor = Colors.purple[400]!;
        break;
      case JobStatus.Izbrisan:
        statusText = 'Izbrisan';
        backgroundColor = Colors.red[400]!;
        break;
      default:
        statusText = 'Unknown';
        backgroundColor = Colors.grey[300]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.1), // Subtle border to add depth
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14, // Adjust font size as needed
        ),
      ),
    );
  }
}

class JobApplicationBadge extends StatelessWidget {
  final JobApplicationStatus status;

  const JobApplicationBadge({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color backgroundColor;
    Color textColor = Colors.white;

    // Customize appearance based on status
    switch (status) {
      case JobApplicationStatus.Poslano:
        statusText = 'Poslano';
        backgroundColor = Colors.blue[400]!;
        break;
      case JobApplicationStatus.Prihvaceno:
        statusText = 'Prihvaćeno';
        backgroundColor = Colors.green[400]!;
        break;
      case JobApplicationStatus.Odbijeno:
        statusText = 'Odbijeno';
        backgroundColor = Colors.red[400]!;
        break;
      default:
        statusText = 'Unknown';
        backgroundColor = Colors.grey[300]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.1), // Subtle border to add depth
          width: 1,
        ),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 14, // Adjust font size as needed
        ),
      ),
    );
  }
}