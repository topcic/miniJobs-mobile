// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedJob _$SavedJobFromJson(Map<String, dynamic> json) => SavedJob(
    id: (json['id'] as num?)?.toInt(),
    created: json['created'] != null
        ? DateTime.parse(json['created'] as String)
        : null,
    createdBy: (json['createdBy'] as num?)?.toInt(),
    applicantFullName: json['applicantFullName'] as String?,
    // Fixed type
    jobName: json['jobName'] as String?,
    jobId: (json['jobId'] as num?)?.toInt(),
    isDeleted: json['isDeleted'] as bool?);
