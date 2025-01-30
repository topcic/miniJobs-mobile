import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../responsve.dart';
import 'info_card.dart';

class MyData extends StatelessWidget {
  const MyData({
    Key? key,
  }) : super(key: key);

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
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    final List<DemoData> demoData = [
      DemoData(title: "Aplikanti", total: 1250, icon: Icons.person),
      DemoData(title: "Poslodavci", total: 340, icon: Icons.business),
      DemoData(title: "Objavljeni poslovi", total: 870, icon: Icons.work),
      DemoData(title: "Aktivne prijave", total: 560, icon: Icons.check_circle),
      DemoData(title: "Prosj. ocjena aplikanta", total: 4, icon: Icons.star),
      DemoData(title: "Prosj. ocjena poslodavca", total: 4, icon: Icons.star_half),
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
