import 'package:json_annotation/json_annotation.dart';

part 'saved_job.g.dart';

@JsonSerializable()
class SavedJob {
  int? id;
  DateTime? created;
  int? createdBy;
  String? applicantFullName;
  String? jobName;
  int? jobId;
  bool? isDeleted;


  SavedJob({
    this.id,
    this.created,
    this.createdBy,
    this.applicantFullName,
    this.jobName,
    this.jobId,
    this.isDeleted
  });

  factory SavedJob.fromJson(Map<String, dynamic> json) =>
      _$SavedJobFromJson(json);
}