import 'package:json_annotation/json_annotation.dart';

part 'job_recommendation_dto.g.dart';

@JsonSerializable()
class JobRecommendationDto {
  String? applicantFullName;
  List<String>? cities;
  List<String>? jobTypes;

  JobRecommendationDto();

  factory JobRecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$JobRecommendationDtoFromJson(json);

}
