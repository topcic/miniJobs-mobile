import 'package:json_annotation/json_annotation.dart';

import 'job_schedule_info.dart';

part 'job_step2.request.g.dart';

@JsonSerializable()
class JobStep2Request {
  int? jobTypeId;
  int? requiredEmployees;
  JobScheduleInfo? jobSchedule;
  int? applicationsDuration;

  JobStep2Request(this.jobTypeId, this.requiredEmployees, this.jobSchedule, this.applicationsDuration);
  Map<String, dynamic> toJson() => _$JobStep2RequestToJson(this);
}
