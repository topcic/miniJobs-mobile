import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minijobs_admin/pages/main/screens/dashboard/components/storage_info_card.dart';
import 'package:provider/provider.dart';

import '../../../../../models/overall_statistic.dart';
import '../../../../../providers/statistic_provider.dart';
import '../../../constants.dart';
import 'chart.dart';

class StorageDetails extends StatefulWidget {
  const StorageDetails({super.key});

  @override
  _StorageDetailsState createState() => _StorageDetailsState();
}

class _StorageDetailsState extends State<StorageDetails> {
  late Future<OverallStatistic> _statisticsFuture;

  @override
  void initState() {
    super.initState();
    final statisticProvider = context.read<StatisticProvider>();
    _statisticsFuture = statisticProvider.getOverall();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: FutureBuilder<OverallStatistic>(
        future: _statisticsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error loading statistics",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          final stats = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Pregled Statistike",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: defaultPadding),
              const Chart(),

              // Ukupan broj aplikanta
              StorageInfoCard(
                icon: FontAwesomeIcons.userGraduate,
                title: "Ukupan broj aplikanta",
                amountOfFiles: "${stats.totalApplicants}",
                numOfFiles: stats.totalApplicants,
              ),

              // Ukupan broj poslodavaca
              StorageInfoCard(
                icon: FontAwesomeIcons.briefcase,
                title: "Ukupan broj poslodavaca",
                amountOfFiles: "${stats.totalEmployers}",
                numOfFiles: stats.totalEmployers,
              ),

              // Broj objavljenih poslova
              StorageInfoCard(
                icon: FontAwesomeIcons.clipboardList,
                title: "Broj objavljenih poslova",
                amountOfFiles: "${stats.totalJobs}",
                numOfFiles: stats.totalJobs,
              ),

              // Aktivne prijave
              StorageInfoCard(
                icon: FontAwesomeIcons.paperPlane,
                title: "Aktivne prijave",
                amountOfFiles: "${stats.totalActiveJobs}",
                numOfFiles: stats.totalActiveJobs,
              ),

              // Prosječna ocjena aplikanta
              StorageInfoCard(
                icon: FontAwesomeIcons.star,
                title: "Prosječna ocjena aplikanta",
                amountOfFiles: stats.averageApplicantRating.toStringAsFixed(1),
                numOfFiles: stats.averageApplicantRating.toInt(),
              ),

              // Prosječna ocjena poslodavaca
              StorageInfoCard(
                icon: FontAwesomeIcons.starHalfAlt,
                title: "Prosječna ocjena poslodavaca",
                amountOfFiles: stats.averageEmployerRating.toStringAsFixed(1),
                numOfFiles: stats.averageEmployerRating.toInt(),
              ),
            ],
          );
        },
      ),
    );
  }
}
