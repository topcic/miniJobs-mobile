import 'package:json_annotation/json_annotation.dart';
import 'job/job_card_dto.dart';

part 'recommendation_result.g.dart';

@JsonSerializable()
class RecommendationResult {
  List<JobCardDTO>? jobs;
  String? reason;

  RecommendationResult(this.jobs, this.reason);

  factory RecommendationResult.fromJson(Map<String, dynamic> json) => _$RecommendationResultFromJson(json);

}
