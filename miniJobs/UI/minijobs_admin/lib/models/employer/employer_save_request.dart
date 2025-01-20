import 'package:json_annotation/json_annotation.dart';

part 'employer_save_request.g.dart';

@JsonSerializable()
class EmployerSaveRequest  {
  String? name;
  String? streetAddressAndNumber;
  String? idNumber;
  String? companyPhoneNumber;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  int? cityId;

  EmployerSaveRequest(
      this.name,
      this.streetAddressAndNumber,
      this.idNumber,
      this.companyPhoneNumber,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.cityId);

  factory EmployerSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$EmployerSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerSaveRequestToJson(this);
}
