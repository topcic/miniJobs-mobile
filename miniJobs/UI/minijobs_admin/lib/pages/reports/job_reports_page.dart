import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import '../../enumerations/job_statuses.dart';
import '../../models/job/job.dart';
import '../../providers/report_provider.dart';
import 'package:flutter/rendering.dart';

class JobReportsPage extends StatefulWidget {
  const JobReportsPage({super.key});

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

  // Global keys for capturing charts
  final GlobalKey statusChartKey = GlobalKey();
  final GlobalKey cityChartKey = GlobalKey();
  final GlobalKey categoryChartKey = GlobalKey();
  final GlobalKey monthlyChartKey = GlobalKey();

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
        return "Kreiran";
      case JobStatus.Aktivan:
        return "Aktivan";
      case JobStatus.AplikacijeZavrsene:
        return "Aplikacije završene";
      case JobStatus.Zavrsen:
        return "Završen";
      case JobStatus.Izbrisan:
        return "Izbrisan";
      default:
        return "Unknown";
    }
  }

  Color _getStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.Kreiran:
        return Colors.greenAccent;
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
            'Izvjestaji - poslovi',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Ukupan broj poslova: ${jobs.length}'),
          pw.SizedBox(height: 20),

          // Job Status Pie Chart
          pw.Text('Distribucija poslova prema statusu'),
          if (statusChartImage != null)
            pw.Image(pw.MemoryImage(statusChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Top 5 Cities Bar Chart
          pw.Text('Gradovi sa najvise poslova'),
          if (cityChartImage != null)
            pw.Image(pw.MemoryImage(cityChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Top 5 Job Types Bar Chart
          pw.Text('Tipovi poslova koji dominiraju'),
          if (categoryChartImage != null)
            pw.Image(pw.MemoryImage(categoryChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Monthly Job Count Bar Chart
          pw.Text('Broj poslova u zadnjih 12 mjeseca'),
          if (monthlyChartImage != null)
            pw.Image(pw.MemoryImage(monthlyChartImage), height: 200),
        ],
      ),
    );

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF Report',
      fileName: 'job_reports.pdf',
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
        title: const Text('Izvještaji o poslovima'),
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
              const Text("Poslovi pregled",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)), // Blue header
              const SizedBox(height: 20),

              // Pie Chart for Job Status
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
                child: Text('Gradovi sa najviše poslova',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)), // Blue header
              ),
              const SizedBox(height: 20),
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
                            )
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
                                      color: Colors.blue), // Blue labels
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
                                    cityJobCount.keys
                                        .elementAt(index),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue), // Blue labels
                                  ),
                                );
                              }
                              return Container();
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Tipovi poslova koji dominiraju',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)), // Blue header
              ),
              const SizedBox(height: 20),
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
                            )
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
                                      color: Colors.blue), // Blue labels
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
                                        color: Colors.blue), // Blue labels
                                  ),
                                );
                              }
                              return Container();
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text('Broj poslova u zadnjih 12 mjeseca',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue)), // Blue header
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: monthlyChartKey,
                child: SizedBox(
                  height: 300,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      barGroups: monthlyJobCount.entries.map((entry) {
                        return BarChartGroupData(
                          x: monthlyJobCount.keys
                              .toList()
                              .indexOf(entry.key),
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
                                      color: Colors.blue), // Blue labels
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
                                      monthlyJobCount.keys.length) {
                                return SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  child: Text(
                                    monthlyJobCount.keys
                                        .elementAt(index),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.blue), // Blue labels
                                  ),
                                );
                              }
                              return Container();
                            },
                            reservedSize: 40,
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
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