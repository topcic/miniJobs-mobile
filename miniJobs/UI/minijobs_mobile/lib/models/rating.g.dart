// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      id: (json['id'] as num).toInt(), // Ensure conversion from num to int
      comment: json['comment'] as String? ?? '', // Default to empty string if null
      value: (json['value'] as num).toInt(), // Ensure conversion from num to int
      jobApplicationId: (json['jobApplicationId'] as num).toInt(), // Ensure conversion from num to int
      ratedUserId: (json['ratedUserId'] as num).toInt(), // Ensure conversion from num to int
      createdByFullName: json['createdByFullName'] as String? ?? '', // Default to empty string if null
      created: DateTime.parse(json['created'] as String), // Parse DateTime from string
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'value': instance.value,
      'jobApplicationId': instance.jobApplicationId,
      'ratedUserId': instance.ratedUserId,
      'createdByFullName': instance.createdByFullName,
      'created': instance.created.toIso8601String(), // Convert DateTime to string
    };
