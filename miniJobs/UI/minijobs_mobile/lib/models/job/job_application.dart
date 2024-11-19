import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_mobile/models/job/job.dart';

import '../../enumerations/job_application_status.dart';

part 'job_application.g.dart';
@JsonSerializable()
class JobApplication {
  int? id;
  JobApplicationStatus? status;
  int? jobId;
  DateTime? created;
  int? createdBy;
  Job? job;
  JobApplication();
  JobApplication.withData(this.id, this.status, this.jobId,
      this.created,this.createdBy);

  factory JobApplication.fromJson(Map<String, dynamic> json) => _$JobApplicationFromJson(json);

  Map<String, dynamic> toJson() => _$JobApplicationToJson(this);
}
