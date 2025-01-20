import 'dart:convert';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/models/job_type.dart';
import 'package:minijobs_admin/models/user/user.dart';

import '../../enumerations/job_application_status.dart';

part 'applicant.g.dart';
@JsonSerializable()
class Applicant extends User {
  Uint8List? cv;
  String? description;
  String? experience;
  Decimal? wageProposal;
  JobType? jobType;
  int? numberOfFinishedJobs;
  Decimal? averageRating;
  List<JobType>? jobTypes;
  int?  jobApplicationId;
  bool? isRated;
  JobApplicationStatus? applicationStatus;

  Applicant(
      super.id,
      super.firstName,
      super.lastName,
      super.fullName,
      super.email,
      super.phoneNumber,
      super.role,
      super.deleted,
      super.accountConfirmed,
      super.photo,
      super.cityId,
      super.city,
      this.cv,
      this.description,
      this.experience,
      this.wageProposal,
      this.jobType,
      this.numberOfFinishedJobs,
      this.averageRating,
      this.jobTypes,
      this.jobApplicationId,
      this.isRated,
      this.applicationStatus);

  factory Applicant.fromJson(Map<String, dynamic> json) => _$ApplicantFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ApplicantToJson(this);
}