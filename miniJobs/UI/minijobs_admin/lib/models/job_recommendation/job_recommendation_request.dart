import 'package:json_annotation/json_annotation.dart';

part 'job_recommendation_request.g.dart';

@JsonSerializable()
class JobRecommendationRequest {
  List<int>? cities;
  List<int>? jobTypes;

  JobRecommendationRequest({this.cities, this.jobTypes});

  factory JobRecommendationRequest.fromJson(Map<String, dynamic> json) =>
      _$JobRecommendationRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JobRecommendationRequestToJson(this);
}
