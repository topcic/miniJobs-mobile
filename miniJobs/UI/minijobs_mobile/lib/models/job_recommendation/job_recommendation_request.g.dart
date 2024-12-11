part of 'job_recommendation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobRecommendationRequest _$JobRecommendationRequestFromJson(Map<String, dynamic> json) => JobRecommendationRequest()
  ..cities = (json['cities'] as List<dynamic>?)?.map((e) => e as int).toList()
  ..jobTypes = (json['jobTypes'] as List<dynamic>?)?.map((e) => e as int).toList();

Map<String, dynamic> _$JobRecommendationRequestToJson(JobRecommendationRequest instance) => <String, dynamic>{
  'cities': instance.cities,
  'jobTypes': instance.jobTypes
};