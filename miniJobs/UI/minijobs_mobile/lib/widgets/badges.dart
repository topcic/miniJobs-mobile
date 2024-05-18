import 'package:flutter/material.dart';

// Default Badge Widget
class Badge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const Badge({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[200]!;
    Color textColor = Colors.grey[800]!;

    // Customize appearance based on status
    if (status == 'Obrisan') {
      backgroundColor = Colors.redAccent[100]!;
      textColor = Colors.redAccent[700]!;

    } 
    else if (status == 'Aktivan') {
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

// Job Badge Widget extending Badge
class JobBadge extends StatelessWidget {
  final String status;

  const JobBadge({
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.grey[200]!;
    Color textColor = Colors.grey[800]!;

    // Customize appearance based on status
    if (status == 'Active') {
      backgroundColor = Colors.green[200]!;
    } else if (status == 'Draft') {
      backgroundColor = Colors.grey[200]!;
    }

    return Badge(
      text: status,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }
}
