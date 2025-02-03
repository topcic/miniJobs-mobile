// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobDTO _$JobDTOFromJson(Map<String, dynamic> json) => JobDTO(
  (json['id'] as num).toInt(),
  json['name'] as String? ?? '',
  json['description'] as String? ?? '',
  json['applicationsDuration'] as int?,
    jobStatusFromInt(json['status'] as int?), // Assuming JobStatus is an enum
  json['cityName'] as String? ?? '',
  DateTime.parse(json['created'] as String),
  json['jobTypeName'] as String?,
  (json['createdBy'] as num).toInt(),
  json['employerFullName'] as String? ?? '',
  json['deletedByAdmin'] as bool,
    json['requiredEmployees'] as int?
);

JobStatus? jobStatusFromInt(int? status) {
  if (status == null) return null;
  switch (status) {
    case 0:
      return JobStatus.Kreiran;
    case 1:
      return JobStatus.Aktivan;
    case 2:
      return JobStatus.AplikacijeZavrsene;
    case 3:
      return JobStatus.Zavrsen;
    case 4:
      return JobStatus.Izbrisan;
    default:
      return null;
  }
}