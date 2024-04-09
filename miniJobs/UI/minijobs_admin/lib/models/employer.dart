import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_admin/models/user.dart';
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
      this.name,
      this.streetAddressAndNumber,
      this.idNumber,
      this.companyPhoneNumber);

       factory Employer.fromJson(Map<String, dynamic> json) => _$EmployerFromJson(json);

  Map<String, dynamic> toJson() => _$EmployerToJson(this);
}
