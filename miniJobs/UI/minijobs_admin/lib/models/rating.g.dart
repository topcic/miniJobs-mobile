// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      (json['id'] as num).toInt(),
      json['comment'] as String? ?? '',
      // Default to empty string if null
      (json['value'] as num).toInt(),
      // Ensure conversion from num to int
      (json['jobApplicationId'] as num).toInt(),
      // Ensure conversion from num to int
      (json['ratedUserId'] as num).toInt(),
      // Ensure conversion from num to int
      json['createdByFullName'] as String? ?? '',
      // Default to empty string if null
      DateTime.parse(json['created'] as String),
      // Parse DateTime from string
      json['photo'] == null ? null : base64Decode(json['photo'] as String),
      (json['createdBy'] as num).toInt(),
      json['createdByRole'] as String? ?? '',
      json['ratedUserFullName'] as String? ?? '',
      json['ratedUserRole'] as String? ?? '',
      json['isActive'] as bool,
      json['jobName']as String?
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'value': instance.value,
      'jobApplicationId': instance.jobApplicationId,
      'ratedUserId': instance.ratedUserId,
      'createdByFullName': instance.createdByFullName,
      'created': instance.created.toIso8601String(),
      'photo': instance.photo,
      'createdBy': instance.createdBy,
    };
