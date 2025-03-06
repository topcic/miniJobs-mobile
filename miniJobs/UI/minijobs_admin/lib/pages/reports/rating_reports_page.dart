import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:minijobs_admin/pages/reports/rating_info_card.dart';
import '../../models/rating.dart';
import '../../providers/report_provider.dart';
import 'package:flutter/rendering.dart';

class RatingReportsPage extends StatefulWidget {
  const RatingReportsPage({super.key});

  @override
  _RatingReportsPageState createState() => _RatingReportsPageState();
}

class _RatingReportsPageState extends State<RatingReportsPage> {
  final ReportProvider reportProvider = ReportProvider();
  List<Rating> ratings = [];
  bool isLoading = true;
  String? errorMessage;

  double averageEmployerRating = 0.0;
  double averageApplicantRating = 0.0;
  Map<int, int> ratingDistribution = {};
  Map<String, double> activeRatingsCount = {"Aktivne": 0, "Neaktivne": 0};
  List<Map<String, dynamic>> topRatedEmployers = [];
  List<Map<String, dynamic>> topRatedApplicants = [];
  List<Map<String, dynamic>> worstRatedEmployers = [];
  List<Map<String, dynamic>> worstRatedApplicants = [];

  // Global keys for capturing charts
  final GlobalKey barChartKey = GlobalKey();
  final GlobalKey pieChartKey = GlobalKey();
  final GlobalKey topEmployersChartKey = GlobalKey();
  final GlobalKey topApplicantsChartKey = GlobalKey();
  final GlobalKey worstEmployersChartKey = GlobalKey();
  final GlobalKey worstApplicantsChartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _fetchRatingReports();
  }

  Future<void> _fetchRatingReports() async {
    try {
      ratings = await reportProvider.getRatings();
      List<Rating> activeRatings = ratings.where((r) => r.isActive).toList();

      // Average Ratings Calculation
      var employerRatings =
      activeRatings.where((r) => r.ratedUserRole == 'Employer');
      var applicantRatings =
      activeRatings.where((r) => r.ratedUserRole == 'Applicant');

      if (employerRatings.isNotEmpty) {
        averageEmployerRating =
            employerRatings.map((r) => r.value).reduce((a, b) => a + b) /
                employerRatings.length;
      }
      if (applicantRatings.isNotEmpty) {
        averageApplicantRating =
            applicantRatings.map((r) => r.value).reduce((a, b) => a + b) /
                applicantRatings.length;
      }

      // Rating Distribution
      for (int i = 1; i <= 5; i++) {
        ratingDistribution[i] = activeRatings.where((r) => r.value == i).length;
      }

      activeRatingsCount = {
        "Aktivne": activeRatings.length.toDouble(),
        "Neaktivne": (ratings.length - activeRatings.length).toDouble()
      };

      // Top & Worst Rated Users
      topRatedEmployers = _getTopRatedUsers(employerRatings.toList(), true);
      topRatedApplicants = _getTopRatedUsers(applicantRatings.toList(), true);
      worstRatedEmployers = _getTopRatedUsers(employerRatings.toList(), false);
      worstRatedApplicants =
          _getTopRatedUsers(applicantRatings.toList(), false);

      setState(() => isLoading = false);
    } catch (error) {
      setState(() {
        errorMessage = "Failed to load data: $error";
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getTopRatedUsers(
      List<Rating> ratings, bool highest) {
    Map<int, List<Rating>> groupedRatings = {};

    for (var rating in ratings) {
      groupedRatings.putIfAbsent(rating.ratedUserId, () => []).add(rating);
    }

    List<Map<String, dynamic>> averagedRatings =
    groupedRatings.entries.map((entry) {
      double avgRating =
          entry.value.map((r) => r.value).reduce((a, b) => a + b) /
              entry.value.length;
      return {
        "id": entry.key,
        "fullName": entry.value.first.ratedUserFullName,
        "averageRating": avgRating,
      };
    }).toList();

    averagedRatings.sort((a, b) => highest
        ? b["averageRating"].compareTo(a["averageRating"])
        : a["averageRating"].compareTo(b["averageRating"]));
    return averagedRatings.take(5).toList();
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
    Uint8List? barChartImage = await _captureChart(barChartKey);
    Uint8List? pieChartImage = await _captureChart(pieChartKey);
    Uint8List? topEmployersChartImage = await _captureChart(topEmployersChartKey);
    Uint8List? topApplicantsChartImage = await _captureChart(topApplicantsChartKey);
    Uint8List? worstEmployersChartImage = await _captureChart(worstEmployersChartKey);
    Uint8List? worstApplicantsChartImage = await _captureChart(worstApplicantsChartKey);

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Izvjestaji - ocjene',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Ukupan broj ocjena: ${ratings.length}'),
          pw.SizedBox(height: 20),
          pw.Text('Prosjecna ocjena poslodavaca: ${averageEmployerRating.toStringAsFixed(2)}'),
          pw.SizedBox(height: 10),
          pw.Text('Prosjecna ocjena aplikanata: ${averageApplicantRating.toStringAsFixed(2)}'),
          pw.SizedBox(height: 20),

          // Rating Distribution Bar Chart
          pw.Text('Distribucija ocjena'),
          if (barChartImage != null)
            pw.Image(pw.MemoryImage(barChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Active vs Inactive Pie Chart
          pw.Text('Omjer aktivnih i neaktivnih ocjena'),
          if (pieChartImage != null)
            pw.Image(pw.MemoryImage(pieChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Top Rated Employers Bar Chart
          pw.Text('Najbolje ocjenjeni poslodavci'),
          if (topEmployersChartImage != null)
            pw.Image(pw.MemoryImage(topEmployersChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Top Rated Applicants Bar Chart
          pw.Text('Najbolje ocjenjeni aplikanti'),
          if (topApplicantsChartImage != null)
            pw.Image(pw.MemoryImage(topApplicantsChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Worst Rated Employers Bar Chart
          pw.Text('Najlosije ocjenjeni poslodavci'),
          if (worstEmployersChartImage != null)
            pw.Image(pw.MemoryImage(worstEmployersChartImage), height: 200),
          pw.SizedBox(height: 20),

          // Worst Rated Applicants Bar Chart
          pw.Text('Najlosije ocjenjeni aplikanti'),
          if (worstApplicantsChartImage != null)
            pw.Image(pw.MemoryImage(worstApplicantsChartImage), height: 200),
        ],
      ),
    );

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Save PDF Report',
      fileName: 'rating_reports.pdf',
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
        title: const Text('Izvještaji o ocjenama'),
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
                "Prosječne ocjene",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Blue header
                ),
              ),
              const SizedBox(height: 20),
              _buildAverageRating(context),
              const SizedBox(height: 20),
              const Text(
                "Ocjene pregled",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue, // Blue header
                ),
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: barChartKey,
                child: _buildBarChart(),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Omjer aktivnih i neaktivnih ocjena",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Blue header
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RepaintBoundary(
                key: pieChartKey,
                child: _buildPieChart(),
              ),
              RepaintBoundary(
                key: topEmployersChartKey,
                child: _buildTopRatedUsersChart(
                    "Najbolje ocjenjeni poslodavci", topRatedEmployers),
              ),
              RepaintBoundary(
                key: topApplicantsChartKey,
                child: _buildTopRatedUsersChart(
                    "Najbolje ocjenjeni aplikanti", topRatedApplicants),
              ),
              RepaintBoundary(
                key: worstEmployersChartKey,
                child: _buildTopRatedUsersChart(
                    "Najlošije ocjenjeni poslodavci", worstRatedEmployers),
              ),
              RepaintBoundary(
                key: worstApplicantsChartKey,
                child: _buildTopRatedUsersChart(
                    "Najlošije ocjenjeni aplikanti", worstRatedApplicants),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAverageRating(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    bool isDesktop = width > 800; // Adjust breakpoint as needed

    return isDesktop
        ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingInfoCard(
          title: "Prosj. ocjena poslodavaca",
          rating: averageEmployerRating,
          icon: Icons.star,
        ),
        const SizedBox(width: 16),
        RatingInfoCard(
          title: "Prosječna ocjena aplikanata",
          rating: averageApplicantRating,
          icon: Icons.star,
        ),
      ],
    )
        : Column(
      children: [
        RatingInfoCard(
          title: "Prosječna ocjena poslodavaca",
          rating: averageEmployerRating,
          icon: Icons.star,
        ),
        const SizedBox(height: 16),
        RatingInfoCard(
          title: "Prosj. ocjena aplikanata",
          rating: averageApplicantRating,
          icon: Icons.star,
        ),
      ],
    );
  }

  Widget _buildBarChart() {
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          barGroups: ratingDistribution.entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
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
                getTitlesWidget: (double value, TitleMeta meta) {
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
                getTitlesWidget: (double value, TitleMeta meta) {
                  int rating = value.toInt();
                  if (rating >= 1 && rating <= 5) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        rating.toString(),
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
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: activeRatingsCount.entries.map((entry) {
            return PieChartSectionData(
              title: '${entry.key} (${entry.value.toInt()})',
              value: entry.value,
              color: entry.key == "Aktivne" ? Colors.green : Colors.red,
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
    );
  }

  Widget _buildTopRatedUsersChart(String title, List<Map<String, dynamic>> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue, // Blue header
            ),
          ),
        ),
        const SizedBox(height: 30),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          value.toStringAsFixed(1),
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
                    getTitlesWidget: (double value, TitleMeta meta) {
                      int index = value.toInt();
                      if (index >= 0 && index < users.length) {
                        return Transform.rotate(
                          angle: -0.5, // Slight rotation for better readability
                          child: Text(
                            users[index]["fullName"],
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blue, // Blue labels
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 100, // Ensures space for rotated names
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              barGroups: users.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                      toY: entry.value["averageRating"],
                      color: Colors.orange,
                      width: 20,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}