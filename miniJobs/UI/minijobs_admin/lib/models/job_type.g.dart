// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobType _$JobTypeFromJson(Map<String, dynamic> json) => JobType(
    (json['id'] as num?)?.toInt(),
    json['name'] as String?,
    json['isDeleted'] as bool?);

Map<String, dynamic> _$JobTypeToJson(JobType instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isDeleted': instance.isDeleted,
    };
