part of 'job_recommendation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobRecommendationDto _$JobRecommendationDtoFromJson(Map<String, dynamic> json) => JobRecommendationDto()
  ..applicantFullName = json['applicantFullName'] as String?
  ..cities = (json['cities'] as List<dynamic>?)?.map((e) => e as String).toList()
  ..jobTypes = (json['jobTypes'] as List<dynamic>?)?.map((e) => e as String).toList();
