// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommendation_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecommendationResult _$RecommendationResultFromJson(Map<String, dynamic> json) => RecommendationResult(
  (json['jobs'] as List<dynamic>?)
      ?.map((e) =>
  e == null ? null : JobCardDTO.fromJson(e as Map<String, dynamic>))
      .whereType<JobCardDTO>() // Filter out null values
      .toList(),
  json['reason'] as String?,
);


