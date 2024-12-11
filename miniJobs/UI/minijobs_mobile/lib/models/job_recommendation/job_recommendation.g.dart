part of 'job_recommendation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobRecommendation _$JobRecommendationFromJson(Map<String, dynamic> json) => JobRecommendation()
  ..id = (json['id'] as num?)?.toInt()
  ..cities = (json['cities'] as List<dynamic>?)?.map((e) => e as int).toList()
  ..jobTypes = (json['jobTypes'] as List<dynamic>?)?.map((e) => e as int).toList();

Map<String, dynamic> _$JobRecommendationToJson(JobRecommendation instance) => <String, dynamic>{
  'id': instance.id,
  'cities': instance.cities,
  'jobTypes': instance.jobTypes
};