import 'package:json_annotation/json_annotation.dart';

part 'job_step1_request.g.dart';

@JsonSerializable()
class JobStep1Request {
  String? name;
  String? description;
  String? streetAddressAndNumber;
  int? cityId;


  JobStep1Request(this.name, this.description, this.streetAddressAndNumber, this.cityId);
  Map<String, dynamic> toJson() => _$JobStep1RequestToJson(this);
}
