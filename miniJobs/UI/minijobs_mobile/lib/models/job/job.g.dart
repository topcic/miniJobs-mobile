// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job.withData(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['description'] as String?,
      json['streetAddressAndNumber'] as String?,
      json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      json['applicationsEndTo'] == null
          ? null
          : DateTime.parse(json['applicationsEndTo'] as String),
      jobStatusFromInt(json['status'] as int?),
      (json['requiredEmployees'] as num?)?.toInt(),
      (json['wage'] as num?)?.toInt(),
      json['employer'] == null
          ? null
          : Employer.fromJson(json['employer'] as Map<String, dynamic>),
      (json['state'] as num?)?.toInt(),
      (json['cityId'] as num?)?.toInt(),
    )
      ..created = json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String)
      ..numberOfApplications = (json['numberOfApplications'] as num?)?.toInt();

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'city': instance.city,
      'applicationsEndTo': instance.applicationsEndTo?.toIso8601String(),
      'status': instance.status?.index,
      'requiredEmployees': instance.requiredEmployees,
      'wage': instance.wage,
      'employer': instance.employer,
      'state': instance.state,
      'cityId': instance.cityId,
      'created': instance.created?.toIso8601String(),
      'numberOfApplications': instance.numberOfApplications,
    };

JobStatus? jobStatusFromInt(int? status) {
  if (status == null) return null;
  switch (status) {
    case 0:
      return JobStatus.Kreiran;
    case 1:
      return JobStatus.Aktivan;
    case 2:
      return JobStatus.Zavrsen;
    case 3:
      return JobStatus.Izbrisan;
    default:
      return null;
  }
}