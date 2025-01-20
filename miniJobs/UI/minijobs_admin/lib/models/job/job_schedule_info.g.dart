// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_schedule_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobScheduleInfo _$JobScheduleInfoFromJson(Map<String, dynamic> json) =>
    JobScheduleInfo(
      (json['questionId'] as num?)?.toInt(),
      (json['answers'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$JobScheduleInfoToJson(JobScheduleInfo instance) =>
    <String, dynamic>{
      'questionId': instance.questionId,
      'answers': instance.answers,
    };
