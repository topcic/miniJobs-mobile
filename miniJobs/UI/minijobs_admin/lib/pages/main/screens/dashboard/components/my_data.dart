import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../models/overall_statistic.dart';
import '../../../../../providers/statistic_provider.dart';
import '../../../constants.dart';
import '../../../responsve.dart';
import 'info_card.dart';
class MyData extends StatelessWidget {
  const MyData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
        SizedBox(height: defaultPadding),
        FutureBuilder<OverallStatistic>(
          future: context.read<StatisticProvider>().getOverall(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error loading statistics", style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData) {
              return Center(child: Text("No data available"));
            }

            final stats = snapshot.data!;
            return Responsive(
              mobile: FileInfoCardGridView(
                crossAxisCount: _size.width < 650 ? 2 : 3,
                childAspectRatio: _size.width < 650 ? 1.3 : 1,
                stats: stats,
              ),
              tablet: FileInfoCardGridView(stats: stats),
              desktop: FileInfoCardGridView(
                childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
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
    Key? key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
    required this.stats,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final OverallStatistic stats;

  @override
  Widget build(BuildContext context) {
    final List<DemoData> demoData = [
      DemoData(title: "Poslodavci", total: stats.totalEmployers, icon: FontAwesomeIcons.building),
      DemoData(title: "Aplikanti", total: stats.totalApplicants, icon: FontAwesomeIcons.users),
      DemoData(title: "Objavljeni poslovi", total: stats.totalJobs, icon: FontAwesomeIcons.briefcase),
      DemoData(title: "Aktivne prijave", total: stats.totalActiveJobs, icon: Icons.check_circle),
      DemoData(title: "Prosj. ocjena aplikanta", total: stats.averageApplicantRating.toInt(), icon: Icons.star),
      DemoData(title: "Prosj. ocjena poslodavca", total: stats.averageEmployerRating.toInt(), icon: Icons.star),
    ];

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
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
        total: demoData[index].total,
        icon: demoData[index].icon,
      ),
    );
  }
}

class DemoData {
  final String title;
  final int total;
  final IconData icon;

  DemoData({required this.title, required this.total, required this.icon});
}