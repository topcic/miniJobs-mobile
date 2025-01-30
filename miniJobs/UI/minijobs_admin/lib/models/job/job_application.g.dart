part of 'job_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobApplication _$JobApplicationFromJson(Map<String, dynamic> json) => JobApplication()
  ..id = (json['id'] as num?)?.toInt()
  ..status = jobApplicationStatusFromInt(json['status'] as int?)
  ..jobId = (json['jobId'] as num?)?.toInt()
  ..created =
  json['created'] == null ? null : DateTime.parse(json['created'] as String)
  ..createdBy = (json['createdBy'] as num?)?.toInt()
  ..hasRated = json['hasRated'] as bool? ?? false
  ..job = json['job'] == null
      ? null
      : Job.fromJson(json['job'] as Map<String, dynamic>)
  ..rating = json['rating'] == null
      ? null
      : Rating.fromJson(json['rating'] as Map<String, dynamic>)
..createdByName= json['createdByName'] as String? ?? null;


Map<String, dynamic> _$JobApplicationToJson(JobApplication instance) => <String, dynamic>{
  'id': instance.id,
  'status': instance.status?.index,
  'created': instance.created?.toIso8601String(),
  'jobId': instance.jobId,
  'createdBy': instance.createdBy,
  'job': instance.job,
  'hasRated': instance.hasRated,
};

JobApplicationStatus? jobApplicationStatusFromInt(int? status) {
  if (status == null) return null;
  switch (status) {
    case 0:
      return JobApplicationStatus.Poslano;
    case 1:
      return JobApplicationStatus.Prihvaceno;
    case 2:
      return JobApplicationStatus.Odbijeno;
    default:
      return null;
  }
}
