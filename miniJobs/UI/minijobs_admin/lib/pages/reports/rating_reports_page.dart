import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:minijobs_admin/pages/reports/rating_info_card.dart';
import '../../models/rating.dart';
import '../../providers/report_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Izvještaji o ocjenama')),
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
                        const Text("Prosječne ocjene",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        _buildAverageRating(context),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Ocjene pregled",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildBarChart(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text("Omjer aktivnih i nekativnih ocjena",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        _buildPieChart(),
                        _buildTopRatedUsersChart(
                            "Najbolje ocjenjeni poslodavci", topRatedEmployers),
                        _buildTopRatedUsersChart(
                            "Najbolje ocjenjeni aplikanti", topRatedApplicants),
                        _buildTopRatedUsersChart(
                            "Najlošije ocjenjeni poslodavci",
                            worstRatedEmployers),
                        _buildTopRatedUsersChart(
                            "Najlošije ocjenjeni aplikanti",
                            worstRatedApplicants),
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
                    toY: entry.value.toDouble(), color: Colors.blue, width: 20)
              ],
            );
          }).toList(),
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
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTopRatedUsersChart(
      String title, List<Map<String, dynamic>> users) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
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
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 100, // Ensures space for rotated names
                  ),
                ),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              barGroups: users.asMap().entries.map((entry) {
                return BarChartGroupData(
                  x: entry.key,
                  barRods: [
                    BarChartRodData(
                        toY: entry.value["averageRating"],
                        color: Colors.orange,
                        width: 20)
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
