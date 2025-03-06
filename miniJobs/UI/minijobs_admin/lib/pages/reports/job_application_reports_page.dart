import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:minijobs_admin/enumerations/job_application_status.dart';
import '../../models/job/job_application.dart';
import '../../providers/report_provider.dart';
import 'package:flutter/rendering.dart';

class JobApplicationReportsPage extends StatefulWidget {
  const JobApplicationReportsPage({super.key});

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

  // Global keys for capturing charts
  final GlobalKey statusChartKey = GlobalKey();
  final GlobalKey cityChartKey = GlobalKey();
  final GlobalKey categoryChartKey = GlobalKey();
  final GlobalKey monthlyChartKey = GlobalKey();

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
        return Colors.tealAccent;
      case JobApplicationStatus.Prihvaceno:
        return Colors.green;
      case JobApplicationStatus.Odbijeno:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<Uint8List?> _captureChart(GlobalKey key) async {
    try {
      RenderRepaintBoundary? boundary =
      key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      print("Error capturing chart: $e");
      return null;
    }
  }

  void _exportToPdf() async {
    final pdf = pw.Document();

    // Capture chart images
    Uint8List? statusChartImage = await _captureChart(statusChartKey);
    Uint8List? cityChartImage = await _captureChart(cityChartKey);
    Uint8List? categoryChartImage = await _captureChart(categoryChartKey);
    Uint8List? monthlyChartImage = await _captureChart(monthlyChartKey);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Izvjestaji - aplikacije za poslove',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Ukupan broj aplikacija: ${jobApplications.length}'),
          pw.SizedBox(height: 20),

          // Job Application Status Pie Chart
          pw.Text('Distribucija aplikacija prema statusu'),
          if (statusChartImage != null)
            pw.Image(pw.MemoryImage(statusChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Top 5 Cities Bar Chart
          pw.Text('Gradovi sa najvise aplikacija'),
          if (cityChartImage != null)
            pw.Image(pw.MemoryImage(cityChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Top 5 Job Types Bar Chart
          pw.Text('Najtrazeniji tipovi posla za aplikante'),
          if (categoryChartImage != null)
            pw.Image(pw.MemoryImage(categoryChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Monthly Application Count Bar Chart
          pw.Text('Broj aplikacija u zadnjih 12 mjeseca'),
          if (monthlyChartImage != null)
            pw.Image(pw.MemoryImage(monthlyChartImage), height: 200),
        ],
      ),
    );

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF Report',
      fileName: 'job_application_reports.pdf',
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = File(result);
      await file.writeAsBytes(await pdf.save());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Izvještaji o aplikacijama za poslove'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _exportToPdf,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage != null
            ? Center(
            child: Text(errorMessage!,
                style: const TextStyle(color: Colors.red)))
            : SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                "Aplikacije pregled",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Blue header
                ),
              ),
              const SizedBox(height: 20),

              // Pie Chart for Job Application Status
              RepaintBoundary(
                key: statusChartKey,
                child: SizedBox(
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
                            color: Colors.blue, // Blue labels
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Gradovi sa najviše aplikacija',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Blue header
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bar Chart for Top 5 Cities with Most Applications
              RepaintBoundary(
                key: cityChartKey,
                child: SizedBox(
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
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget:
                                (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue, // Blue labels
                                  ),
                                ),
                              );
                            },
                          ),
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
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue, // Blue labels
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Najtraženiji tipovi posla za aplikante',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Blue header
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bar Chart for Top 5 Job Types with Most Applications
              RepaintBoundary(
                key: categoryChartKey,
                child: SizedBox(
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
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget:
                                (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue, // Blue labels
                                  ),
                                ),
                              );
                            },
                          ),
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
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue, // Blue labels
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  'Broj aplikacija na poslove u zadnjih 12 mjeseca',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Blue header
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bar Chart for Applications Created Per Month
              RepaintBoundary(
                key: monthlyChartKey,
                child: SizedBox(
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
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget:
                                (double value, TitleMeta meta) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue, // Blue labels
                                  ),
                                ),
                              );
                            },
                          ),
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
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue, // Blue labels
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
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