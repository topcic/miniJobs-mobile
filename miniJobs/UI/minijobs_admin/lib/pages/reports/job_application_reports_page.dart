import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:minijobs_admin/enumerations/job_application_status.dart';

import '../../models/job/job_application.dart';
import '../../providers/report_provider.dart';

class JobApplicationReportsPage extends StatefulWidget {
  const JobApplicationReportsPage({Key? key}) : super(key: key);

  @override
  _JobApplicationReportsPageState createState() =>
      _JobApplicationReportsPageState();
}

class _JobApplicationReportsPageState extends State<JobApplicationReportsPage> {
  final ReportProvider reportProvider = ReportProvider();
  Map<JobApplicationStatus, int> jobStatusCount = {};
  Map<String, int> jobCategoryCount = {};
  Map<String, int> cityJobCount = {};
  Map<String, int> monthlyApplicationCount = {};
  List<JobApplication> jobApplications = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJobApplicationReports();
  }

  Future<void> _fetchJobApplicationReports() async {
    try {
      jobApplications = await reportProvider.getJobApplications();
      Map<JobApplicationStatus, int> statusCount = {};
      Map<String, int> categoryCount = {};
      Map<String, int> cityCount = {};
      Map<String, int> monthlyCount = {};

      for (var application in jobApplications) {
        statusCount[application.status!] =
            (statusCount[application.status] ?? 0) + 1;

        if (application.job!.jobType != null) {
          categoryCount[application.job!.jobType!.name!] =
              (categoryCount[application.job!.jobType!.name] ?? 0) + 1;
        }
        if (application.job!.city != null) {
          cityCount[application.job!.city!.name!] =
              (cityCount[application.job!.city!.name] ?? 0) + 1;
        }
        String monthKey =
            "${application.created!.year}-${application.created!.month}";
        monthlyCount[monthKey] = (monthlyCount[monthKey] ?? 0) + 1;
      }

      setState(() {
        jobStatusCount = statusCount;
        jobCategoryCount = _getTopEntries(categoryCount, 5);
        cityJobCount = _getTopEntries(cityCount, 5);
        monthlyApplicationCount = monthlyCount;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = "Failed to load data: $error";
        isLoading = false;
      });
    }
  }

  Map<String, int> _getTopEntries(Map<String, int> data, int topN) {
    var sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return Map.fromEntries(sortedEntries.take(topN));
  }

  String _statusToString(JobApplicationStatus status) {
    switch (status) {
      case JobApplicationStatus.Poslano:
        return "Poslano";
      case JobApplicationStatus.Prihvaceno:
        return "Prihvaćeno";
      case JobApplicationStatus.Odbijeno:
        return "Odbijeno";
      default:
        return "Unknown";
    }
  }

  Color _getStatusColor(JobApplicationStatus status) {
    switch (status) {
      case JobApplicationStatus.Poslano:
        return Colors.blue;
      case JobApplicationStatus.Prihvaceno:
        return Colors.green;
      case JobApplicationStatus.Odbijeno:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Izvještaji o aplikacijama za poslove')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: const CircularProgressIndicator())
            : errorMessage != null
                ? Center(
                    child: Text(errorMessage!,
                        style: const TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        const Text("Aplikacije pregled",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),

                        // Pie Chart for Job Application Status
                        SizedBox(
                          height: 250,
                          child: PieChart(
                            PieChartData(
                              sections: jobStatusCount.entries.map((entry) {
                                return PieChartSectionData(
                                  title:
                                      '${_statusToString(entry.key)} (${entry.value})',
                                  value: entry.value.toDouble(),
                                  color: _getStatusColor(entry.key),
                                  radius: 60,
                                  titleStyle: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('Gradovi sa najviše aplikacija',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 20),
                        // Bar Chart for Top 5 Cities with Most Applications
                        SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: cityJobCount.entries.map((entry) {
                                return BarChartGroupData(
                                  x: cityJobCount.keys
                                      .toList()
                                      .indexOf(entry.key),
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color: Colors.blue,
                                      width: 20,
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true, reservedSize: 40),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      int index = value.toInt();
                                      if (index >= 0 &&
                                          index < cityJobCount.keys.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                            cityJobCount.keys.elementAt(index),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text('Najtraženiji tipovi posla za aplikante',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 20),
                        // Bar Chart for Top 5 Job Types with Most Applications
                        SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: jobCategoryCount.entries.map((entry) {
                                return BarChartGroupData(
                                  x: jobCategoryCount.keys
                                      .toList()
                                      .indexOf(entry.key),
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color: Colors.green,
                                      width: 20,
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true, reservedSize: 40),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      int index = value.toInt();
                                      if (index >= 0 &&
                                          index <
                                              jobCategoryCount.keys.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                            jobCategoryCount.keys
                                                .elementAt(index),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                              'Broj aplikacija na poslove u zadnjih 12 mjeseca',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 20),
                        // Bar Chart for Applications Created Per Month
                        SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups:
                                  monthlyApplicationCount.entries.map((entry) {
                                return BarChartGroupData(
                                  x: monthlyApplicationCount.keys
                                      .toList()
                                      .indexOf(entry.key),
                                  barRods: [
                                    BarChartRodData(
                                      toY: entry.value.toDouble(),
                                      color: Colors.orange,
                                      width: 20,
                                    ),
                                  ],
                                );
                              }).toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                      showTitles: true, reservedSize: 40),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget:
                                        (double value, TitleMeta meta) {
                                      int index = value.toInt();
                                      if (index >= 0 &&
                                          index <
                                              monthlyApplicationCount
                                                  .keys.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(
                                            monthlyApplicationCount.keys
                                                .elementAt(index),
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                    reservedSize: 40,
                                  ),
                                ),
                                topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
