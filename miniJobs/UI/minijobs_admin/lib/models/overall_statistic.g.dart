part of 'overall_statistic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OverallStatistic _$OverallStatisticFromJson(Map<String, dynamic> json) =>
    OverallStatistic(
      (json['totalApplicants'] as num?)?.toInt() ?? 0,
      (json['totalEmployers'] as num?)?.toInt() ?? 0,
      (json['totalJobs'] as num?)?.toInt() ?? 0,
      (json['totalActiveJobs'] as num?)?.toInt() ?? 0,
      (json['averageEmployerRating'] as num?)?.toDouble() ?? 0.0,
      (json['averageApplicantRating'] as num?)?.toDouble() ?? 0.0,
    );


