import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/employer.dart';

part 'job.g.dart';
@JsonSerializable()
class Job {
  int? id;
  String? name;
  String? description;
  String? streetAddressAndNumber;
  City? city;
  DateTime? applicationsEndTo;
  JobStatus? status;
  int? requiredEmployees;
  int? wage;
  Employer? employer;
  int? state;
  int? cityId;
  DateTime? created;
  int? numberOfApplications;

  Job();
  Job.withData(this.id, this.name, this.description, this.streetAddressAndNumber,
      this.city,this.applicationsEndTo,this.status, this.requiredEmployees,this.wage,this.employer,this.state,this.cityId);

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

  Map<String, dynamic> toJson() => _$JobToJson(this);
}
