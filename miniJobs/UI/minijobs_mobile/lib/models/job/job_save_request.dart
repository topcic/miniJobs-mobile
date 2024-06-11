import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_mobile/models/job/job_schedule_info.dart';

part 'job_save_request.g.dart';

@JsonSerializable()
class JobSaveRequest {
  int? id;
  String? name;
  String? description;
  String? streetAddressAndNumber;
  int? cityId;
  int? status;
  int? jobTypeId;
  int? requiredEmployees;
  JobScheduleInfo? jobSchedule;
  Map<int, List<int>>? answersToPaymentQuestions;
  int? wage;
  int? applicationsDuration;

  JobSaveRequest(
      this.id,
      this.name,
      this.description,
      this.streetAddressAndNumber,
      this.cityId,
      this.status,
      this.jobTypeId,
      this.requiredEmployees,
      this.jobSchedule,
      this.answersToPaymentQuestions,
      this.wage,
      this.applicationsDuration);

  factory JobSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$JobSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JobSaveRequestToJson(this);
}
