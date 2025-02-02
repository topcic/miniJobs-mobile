import 'package:flutter/material.dart';
import '../enumerations/job_application_status.dart';
import '../enumerations/job_statuses.dart';

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

class UserBadge extends StatelessWidget {
  final String status;

  const UserBadge({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Map status to colors
    final badgeColors = {
      'Obrisan': [Colors.redAccent[100]!, Colors.redAccent[700]!],
      'Aktivan': [Colors.greenAccent[100]!, Colors.greenAccent[700]!],
    };

    final colors = badgeColors[status] ?? [Colors.grey[200]!, Colors.grey[800]!];

    return Badge(
      text: status,
      backgroundColor: colors[0],
      textColor: colors[1],
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
    // Map status to appearance
    const statusMap = {
      JobStatus.Kreiran: ['Kreiran', Colors.blue],
      JobStatus.Aktivan: ['Aktivan', Colors.green],
      JobStatus.AplikacijeZavrsene: ['Aplikacije završene', Colors.orange],
      JobStatus.Zavrsen: ['Završen', Colors.purple],
      JobStatus.Izbrisan: ['Izbrisan', Colors.red],
    };

    final statusDetails = statusMap[status] ?? ['Unknown', Colors.grey];
    final statusText = statusDetails[0];
    final backgroundColor = (statusDetails[1] as MaterialColor)[400]!;

    return _buildBadge(statusText.toString(), backgroundColor);
  }

  Widget _buildBadge(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 10,
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
    // Map status to appearance
    const statusMap = {
      JobApplicationStatus.Poslano: ['Poslano', Colors.blue],
      JobApplicationStatus.Prihvaceno: ['Prihvaćeno', Colors.green],
      JobApplicationStatus.Odbijeno: ['Odbijeno', Colors.red],
    };

    final statusDetails = statusMap[status] ?? ['Unknown', Colors.grey];
    final statusText = statusDetails[0];
    final backgroundColor = (statusDetails[1] as MaterialColor)[400]!;

    return _buildBadge(statusText.toString(), backgroundColor);
  }

  Widget _buildBadge(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 8,
        ),
      ),
    );
  }
}

class ApplicationActions extends StatelessWidget {
  final JobApplicationStatus status;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ApplicationActions({
    required this.status,
    required this.onAccept,
    required this.onReject,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (status == JobApplicationStatus.Prihvaceno) {
      return const Badge(
        text: 'Prihvaćen',
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else if (status == JobApplicationStatus.Odbijeno) {
      return const Badge(
        text: 'Odbijen',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      return Row(
        children: [
          Tooltip(
            message: 'Prihvati aplikanta',
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Prihvati'),
            ),
          ),
          const SizedBox(width: 8),
          Tooltip(
            message: 'Odbij aplikanta',
            child: ElevatedButton(
              onPressed: onReject,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Odbij'),
            ),
          ),
        ],
      );
    }
  }
}
class UserStatusBadge extends StatelessWidget {
  final bool isBlocked;

  const UserStatusBadge({
    required this.isBlocked,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine text and colors based on the user's blocked status
    final statusText = isBlocked ? 'Blokiran' : 'Aktivan';
    final backgroundColor = isBlocked ? Colors.red[100]! : Colors.green[100]!;
    final textColor = isBlocked ? Colors.red[800]! : Colors.green[800]!;

    return Badge(
      text: statusText,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}

class RatingBadge extends StatelessWidget {
  final bool isActive;

  const RatingBadge({
    required this.isActive,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine text and colors based on the user's blocked status
    final statusText = isActive ? 'Neaktivna' : 'Aktivna';
    final backgroundColor = isActive ? Colors.red[100]! : Colors.green[100]!;
    final textColor = isActive ? Colors.red[800]! : Colors.green[800]!;

    return Badge(
      text: statusText,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}

class SavedJobBadge extends StatelessWidget {
  final bool IsDeleted;

  const SavedJobBadge({
    required this.IsDeleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Determine text and colors based on the user's blocked status
    final statusText = IsDeleted ? 'Obrisan' : 'Aktivan';
    final backgroundColor = IsDeleted ? Colors.red[100]! : Colors.green[100]!;
    final textColor = IsDeleted ? Colors.red[800]! : Colors.green[800]!;

    return Badge(
      text: statusText,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}