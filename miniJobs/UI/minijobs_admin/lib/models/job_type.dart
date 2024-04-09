import 'package:json_annotation/json_annotation.dart';

part 'job_type.g.dart';

@JsonSerializable()
class JobType {
  int? id;
  String? name;

  JobType(this.id, this.name);

  factory JobType.fromJson(Map<String, dynamic> json) => _$JobTypeFromJson(json);

  Map<String, dynamic> toJson() => _$JobTypeToJson(this);
}
