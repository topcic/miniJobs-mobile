import 'dart:convert';
import 'dart:typed_data';
import 'package:decimal/decimal.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_mobile/models/user.dart';

part 'applicant.g.dart';
@JsonSerializable()
class Applicant extends User {
    Uint8List? cv;
    String? description;
    String? experience;
    Decimal? wageProposal;
  
    Applicant(
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
        this.cv,
        this.description,
        this.experience,
        this.wageProposal);
  
         factory Applicant.fromJson(Map<String, dynamic> json) => _$ApplicantFromJson(json);
  
    Map<String, dynamic> toJson() => _$ApplicantToJson(this);
  }