import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_admin/enumerations/job_statuses.dart';

part 'job_dto.g.dart';

@JsonSerializable()
class JobDTO {
  int id;
  String name;
  String description;
  int? applicationsDuration;
  JobStatus? status;
  String cityName;
  String? jobTypeName;
  DateTime created;
  int createdBy;
  String employerFullName;
  bool deletedByAdmin;
  int? requiredEmployees;


  JobDTO(this.id,
      this.name,
      this.description,
      this.applicationsDuration,
      this.status,
      this.cityName,
      this.created,
      this.jobTypeName,
      this.createdBy,
      this.employerFullName,
      this.deletedByAdmin,
      this.requiredEmployees);

  factory JobDTO.fromJson(Map<String, dynamic> json) => _$JobDTOFromJson(json);

}