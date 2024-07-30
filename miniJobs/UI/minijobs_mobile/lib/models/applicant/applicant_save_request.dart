import 'dart:convert';
import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';

part 'applicant_save_request.g.dart';

@JsonSerializable()
class ApplicantSaveRequest  {
  String? firstName;
  String? lastName;
  String? phoneNumber;
  int? cityId;
  String? description;
  String? experience;
  Decimal? wageProposal;
  Uint8List? cvFile;
  String? cvFileName;


  ApplicantSaveRequest(
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.cityId,
      this.description,
      this.experience,
      this.wageProposal,
      this.cvFile,
      this.cvFileName
      );

  factory ApplicantSaveRequest.fromJson(Map<String, dynamic> json) =>
      _$ApplicantSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$ApplicantSaveRequestToJson(this);
}
