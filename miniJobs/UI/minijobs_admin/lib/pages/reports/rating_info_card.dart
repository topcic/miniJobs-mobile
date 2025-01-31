import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main/constants.dart';

class RatingInfoCard extends StatelessWidget {
  const RatingInfoCard({
    Key? key,
    required this.title,
    required this.rating,
    required this.icon,
    this.color = primaryColor,
  }) : super(key: key);

  final String title;
  final double rating;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Adjust width as needed
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: color, size: 24),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding), // Added space
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: defaultPadding * 0.5), // Slightly smaller spacing
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
