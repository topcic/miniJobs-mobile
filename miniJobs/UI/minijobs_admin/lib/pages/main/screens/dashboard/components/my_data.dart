import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../models/overall_statistic.dart';
import '../../../../../providers/statistic_provider.dart';
import '../../../constants.dart';
import '../../../responsve.dart';
import 'info_card.dart';
class MyData extends StatelessWidget {
  const MyData({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Podaci",
              style: Theme.of(context).textTheme.titleMedium,
            )
          ],
        ),
        const SizedBox(height: defaultPadding),
        FutureBuilder<OverallStatistic>(
          future: context.read<StatisticProvider>().getOverall(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error loading statistics", style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData) {
              return const Center(child: Text("No data available"));
            }

            final stats = snapshot.data!;
            return Responsive(
              mobile: FileInfoCardGridView(
                crossAxisCount: size.width < 650 ? 2 : 3,
                childAspectRatio: size.width < 650 ? 1.3 : 1,
                stats: stats,
              ),
              tablet: FileInfoCardGridView(stats: stats),
              desktop: FileInfoCardGridView(
                childAspectRatio: size.width < 1400 ? 1.1 : 1.4,
                stats: stats,
              ),
            );
          },
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    super.key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
    required this.stats,
  });

  final int crossAxisCount;
  final double childAspectRatio;
  final OverallStatistic stats;

  @override
  Widget build(BuildContext context) {
    final List<DemoData> demoData = [
      DemoData(title: "Poslodavci", total: stats.totalEmployers.toString(), icon: FontAwesomeIcons.building),
      DemoData(title: "Aplikanti", total: stats.totalApplicants.toString(), icon: FontAwesomeIcons.users),
      DemoData(title: "Objavljeni poslovi", total: stats.totalJobs.toString(), icon: FontAwesomeIcons.briefcase),
      DemoData(title: "Aktivni poslovi", total: stats.totalActiveJobs.toString(), icon: Icons.check_circle),
      DemoData(title: "Prosj. ocjena aplikanta", total: stats.averageApplicantRating.toString(), icon: Icons.star),
      DemoData(title: "Prosj. ocjena poslodavca", total: stats.averageEmployerRating.toString(), icon: Icons.star),
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => InfoCard(
        title: demoData[index].title,
        total: demoData[index].total.toString(),
        icon: demoData[index].icon,
      ),
    );
  }
}

class DemoData {
  final String title;
  final String total;
  final IconData icon;

  DemoData({required this.title, required this.total, required this.icon});
}