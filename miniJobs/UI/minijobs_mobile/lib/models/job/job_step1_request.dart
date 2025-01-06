import 'package:json_annotation/json_annotation.dart';

part 'job_insert_request.g.dart';

@JsonSerializable()
class JobInsertRequest {
  String? name;
  String? description;
  String? streetAddressAndNumber;
  int? cityId;


  JobInsertRequest(this.name, this.description, this.streetAddressAndNumber, this.cityId);

  factory JobInsertRequest.fromJson(Map<String, dynamic> json) => _$JobInsertRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JobInsertRequestToJson(this);
}
