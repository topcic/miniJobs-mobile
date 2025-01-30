import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

final testData = {
  "totalApplicants": 1250, // Ukupan broj aplikanta
  "totalEmployers": 340, // Ukupan broj poslodavaca
  "jobsPosted": 870, // Broj objavljenih poslova
  "activeApplications": 560, // Aktivne prijave
  "averageRatingApplicants": 4.5, // Prosječna ocjena aplikanta
  "averageRatingEmployers": 4.2, // Prosječna ocjena poslodavaca
};

class StorageDetails extends StatelessWidget {
  const StorageDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pregled Statistike",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),

          // Ukupan broj aplikanta
          StorageInfoCard(
            icon: FontAwesomeIcons.userGraduate,
            title: "Ukupan broj aplikanta",
            amountOfFiles: "${testData["totalApplicants"]}",
            numOfFiles: testData["totalApplicants"] as int,
          ),

          // Ukupan broj poslodavaca
          StorageInfoCard(
            icon: FontAwesomeIcons.briefcase,
            title: "Ukupan broj poslodavaca",
            amountOfFiles: "${testData["totalEmployers"]}",
            numOfFiles: testData["totalEmployers"] as int,
          ),

          // Broj objavljenih poslova
          StorageInfoCard(
            icon: FontAwesomeIcons.clipboardList,
            title: "Broj objavljenih poslova",
            amountOfFiles: "${testData["jobsPosted"]}",
            numOfFiles: testData["jobsPosted"] as int,
          ),

          // Aktivne prijave
          StorageInfoCard(
            icon: FontAwesomeIcons.paperPlane,
            title: "Aktivne prijave",
            amountOfFiles: "${testData["activeApplications"]}",
            numOfFiles: testData["activeApplications"] as int,
          ),

          // Prosječna ocjena aplikanta
          StorageInfoCard(
            icon: FontAwesomeIcons.star,
            title: "Prosječna ocjena aplikanta",
            amountOfFiles: "${testData["averageRatingApplicants"]}",
            numOfFiles: testData["averageRatingApplicants"]!.toInt(),
          ),

          // Prosječna ocjena poslodavaca
          StorageInfoCard(
            icon: FontAwesomeIcons.starHalfAlt,
            title: "Prosječna ocjena poslodavaca",
            amountOfFiles: "${testData["averageRatingEmployers"]}",
            numOfFiles: testData["averageRatingEmployers"]!.toInt(),
          ),
        ],
      ),
    );
  }
}
