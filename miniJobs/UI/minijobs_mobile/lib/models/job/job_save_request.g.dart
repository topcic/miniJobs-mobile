// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobSaveRequest _$JobSaveRequestFromJson(Map<String, dynamic> json) =>
    JobSaveRequest(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['description'] as String?,
      json['streetAddressAndNumber'] as String?,
      (json['cityId'] as num?)?.toInt(),
      (json['status'] as num?)?.toInt(),
      (json['jobTypeId'] as num?)?.toInt(),
      (json['requiredEmployees'] as num?)?.toInt(),
      json['jobSchedule'] == null
          ? null
          : JobScheduleInfo.fromJson(
              json['jobSchedule'] as Map<String, dynamic>),
      (json['answersToPaymentQuestions'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(int.parse(k),
            (e as List<dynamic>).map((e) => (e as num).toInt()).toList()),
      ),
      (json['wage'] as num?)?.toInt(),
      (json['applicationsDuration'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JobSaveRequestToJson(JobSaveRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'cityId': instance.cityId,
      'status': instance.status,
      'jobTypeId': instance.jobTypeId,
      'requiredEmployees': instance.requiredEmployees,
      'jobSchedule': instance.jobSchedule,
      'answersToPaymentQuestions': instance.answersToPaymentQuestions
          ?.map((k, e) => MapEntry(k.toString(), e)),
      'wage': instance.wage,
      'applicationsDuration': instance.applicationsDuration,
    };
