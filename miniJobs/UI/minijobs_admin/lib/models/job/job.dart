import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_admin/enumerations/job_statuses.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/models/employer/employer.dart';
import 'package:minijobs_admin/models/job_type.dart';
import 'package:minijobs_admin/models/proposed_answer.dart';

part 'job.g.dart';
@JsonSerializable()
class Job {
  int? id;
  String? name;
  String? description;
  String? streetAddressAndNumber;
  City? city;
  int? applicationsDuration;
  JobStatus? status;
  int? requiredEmployees;
  int? wage;
  Employer? employer;
  int? state;
  int? cityId;
  DateTime? created;
  int? numberOfApplications;
  int? jobTypeId;
  JobType? jobType;
  List<ProposedAnswer>? schedules;
  ProposedAnswer? paymentQuestion;
  List<ProposedAnswer>? additionalPaymentOptions;
  String? employerFullName;
  bool isApplied = false;
  bool isSaved = false;
  int? createdBy;
  DateTime? applicationsStart;
  bool deletedByAdmin=false;
  Job();
  Job.withData(this.id, this.name, this.description, this.streetAddressAndNumber,
      this.city,this.applicationsDuration,this.status, this.requiredEmployees,
      this.wage,this.employer,this.state,this.cityId,
      this.employerFullName,this.isApplied,this.isSaved,this.applicationsStart,this.deletedByAdmin);

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);
}
