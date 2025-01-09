import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/user/user.dart';
part 'employer.g.dart';

@JsonSerializable()
class Employer extends User {
  String? name;
  String? streetAddressAndNumber;
  String? idNumber;
  String? companyPhoneNumber;
  Decimal? averageRating;

  Employer(
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
      this.name,
      this.streetAddressAndNumber,
      this.idNumber,
      this.companyPhoneNumber,
      this.averageRating);

  factory Employer.fromJson(Map<String, dynamic> json) =>
      _$EmployerFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EmployerToJson(this);
}
