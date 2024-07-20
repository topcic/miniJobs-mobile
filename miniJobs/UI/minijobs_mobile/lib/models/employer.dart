import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_mobile/models/user.dart';
part 'employer.g.dart';

@JsonSerializable()
class Employer extends User {
  String? name;
  String? streetAddressAndNumber;
  String? idNumber;
  String? companyPhoneNumber;

  Employer(
      super.id,
      super.firstName,
      super.lastName,
      super.userName,
      super.email,
      super.phoneNumber,
      super.role,
      super.deleted,
      super.accountConfirmed,
      super.photo,
      this.name,
      this.streetAddressAndNumber,
      this.idNumber,
      this.companyPhoneNumber);

       factory Employer.fromJson(Map<String, dynamic> json) => _$EmployerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmployerToJson(this);
}
