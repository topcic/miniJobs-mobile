import 'package:json_annotation/json_annotation.dart';

part 'overall_statistic.g.dart';

@JsonSerializable()
class OverallStatistic {
  int totalApplicants;
  int totalEmployers;
  int totalJobs;
  int totalActiveJobs;
  double averageEmployerRating;
  double averageApplicantRating;

  OverallStatistic(
      this.totalApplicants,
      this.totalEmployers,
      this.totalJobs,
      this.totalActiveJobs,
      this.averageEmployerRating,
      this.averageApplicantRating,
      );

  factory OverallStatistic.fromJson(Map<String, dynamic> json) =>
      _$OverallStatisticFromJson(json);
}
