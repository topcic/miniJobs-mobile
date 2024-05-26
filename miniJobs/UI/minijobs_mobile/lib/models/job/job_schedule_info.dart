import 'package:json_annotation/json_annotation.dart';

part 'job_schedule_info.g.dart';

@JsonSerializable()
class JobScheduleInfo {
  int? questionId;
  List<int>? answers;

  JobScheduleInfo(this.questionId, this.answers);

  factory JobScheduleInfo.fromJson(Map<String, dynamic> json) =>
      _$JobScheduleInfoFromJson(json);

  Map<String, dynamic> toJson() => _$JobScheduleInfoToJson(this);
}
