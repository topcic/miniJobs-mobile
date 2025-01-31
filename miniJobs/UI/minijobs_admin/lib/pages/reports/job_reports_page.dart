import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../enumerations/job_statuses.dart';
import '../../models/job/job.dart';
import '../../providers/report_provider.dart';

class JobReportsPage extends StatefulWidget {
  @override
  _JobReportsPageState createState() => _JobReportsPageState();
}

class _JobReportsPageState extends State<JobReportsPage> {
  final ReportProvider reportProvider = ReportProvider();
  Map<JobStatus, int> jobStatusCount = {};
  Map<String, int> jobCategoryCount = {};
  Map<String, int> cityJobCount = {};
  Map<String, int> monthlyJobCount = {};
  List<Job> jobs = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchJobReports();
  }

  Future<void> _fetchJobReports() async {
    try {
      jobs = await reportProvider.getJobs();
      Map<JobStatus, int> statusCount = {};
      Map<String, int> categoryCount = {};
      Map<String, int> cityCount = {};
      Map<String, int> monthlyCount = {};

      for (var job in jobs) {
        statusCount[job.status!] = (statusCount[job.status] ?? 0) + 1;
        if (job.jobType != null) {
          categoryCount[job.jobType!.name!] =
              (categoryCount[job.jobType!.name] ?? 0) + 1;
        }
        if (job.city != null) {
          cityCount[job.city!.name!] = (cityCount[job.city!.name] ?? 0) + 1;
        }
        String monthKey = "${job.created!.year}-${job.created!.month}";
        monthlyCount[monthKey] = (monthlyCount[monthKey] ?? 0) + 1;
      }

      setState(() {
        jobStatusCount = statusCount;
        jobCategoryCount = _getTopEntries(categoryCount, 5);
        cityJobCount = _getTopEntries(cityCount, 5);
        monthlyJobCount = monthlyCount;
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

  String _statusToString(JobStatus status) {
    switch (status) {
      case JobStatus.Kreiran:
        return "Created";
      case JobStatus.Aktivan:
        return "Active";
      case JobStatus.AplikacijeZavrsene:
        return "Applications Closed";
      case JobStatus.Zavrsen:
        return "Completed";
      case JobStatus.Izbrisan:
        return "Deleted";
      default:
        return "Unknown";
    }
  }

  Color _getStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.Kreiran:
        return Colors.blue;
      case JobStatus.Aktivan:
        return Colors.green;
      case JobStatus.AplikacijeZavrsene:
        return Colors.orange;
      case JobStatus.Zavrsen:
        return Colors.purple;
      case JobStatus.Izbrisan:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Job Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
            child: Text(errorMessage!,
                style: TextStyle(color: Colors.red)))
            : SingleChildScrollView(
          child: Column(
            children: [
              Text("Job Reports Overview",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),

              // Pie Chart for Job Status
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
                        titleStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Bar Chart for Top 5 Cities with Most Jobs
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: cityJobCount.entries.map((entry) {
                      return BarChartGroupData(
                        x: cityJobCount.keys.toList().indexOf(entry.key), // Index as X value
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.toDouble(),
                            color: Colors.blue,
                            width: 20,
                          )
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < cityJobCount.keys.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  cityJobCount.keys.elementAt(index),
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            }
                            return Container();
                          },
                          reservedSize: 40, // Space for city names
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide top labels
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide right labels
                      ),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20),

              // Bar Chart for Top 5 Job Types with Most Jobs
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: jobCategoryCount.entries.map((entry) {
                      return BarChartGroupData(
                        x: jobCategoryCount.keys.toList().indexOf(entry.key), // Index as X value
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.toDouble(),
                            color: Colors.green,
                            width: 20,
                          )
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < jobCategoryCount.keys.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  jobCategoryCount.keys.elementAt(index),
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            }
                            return Container();
                          },
                          reservedSize: 40, // Space for job type labels
                        ),

                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide top labels
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide right labels
                      ),
                    ),
                  ),
                ),
              ),


              SizedBox(height: 20),

              // Line Chart for Jobs Created Per Month
              SizedBox(
                height: 300,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    barGroups: monthlyJobCount.entries.map((entry) {
                      return BarChartGroupData(
                        x: monthlyJobCount.keys.toList().indexOf(entry.key), // Index as X value
                        barRods: [
                          BarChartRodData(
                            toY: entry.value.toDouble(),
                            color: Colors.orange,
                            width: 20,
                          )
                        ],
                      );
                    }).toList(),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < monthlyJobCount.keys.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  monthlyJobCount.keys.elementAt(index), // Display "YYYY-MM"
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return Container();
                          },
                          reservedSize: 40, // Space for labels
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide top labels
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false), // Hide right labels
                      ),
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