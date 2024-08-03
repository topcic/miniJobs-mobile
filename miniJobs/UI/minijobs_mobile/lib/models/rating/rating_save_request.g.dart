// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingSaveRequest _$RatingSaveRequestFromJson(Map<String, dynamic> json) => RatingSaveRequest(
    json['comment'] as String? ?? '', // Default to empty string if null
    (json['value'] as num).toInt(), // Ensure conversion from num to int
    (json['jobApplicationId'] as num).toInt(), // Ensure conversion from num to int
    (json['ratedUserId'] as num).toInt(), // Ensure conversion from num to int
);

Map<String, dynamic> _$RatingSaveRequestToJson(RatingSaveRequest instance) => <String, dynamic>{
  'comment': instance.comment,
  'value': instance.value,
  'jobApplicationId': instance.jobApplicationId,
  'ratedUserId': instance.ratedUserId
};
