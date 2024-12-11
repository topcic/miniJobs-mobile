import 'package:json_annotation/json_annotation.dart';

part 'job_recommendation.g.dart';

@JsonSerializable()
class JobRecommendation {
  int? id;
  List<int>? cities;
  List<int>? jobTypes;

  JobRecommendation();

  factory JobRecommendation.fromJson(Map<String, dynamic> json) =>
      _$JobRecommendationFromJson(json);

  Map<String, dynamic> toJson() => _$JobRecommendationToJson(this);
}
