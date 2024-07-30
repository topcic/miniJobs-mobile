// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApplicantSaveRequest _$ApplicantSaveRequestFromJson(Map<String, dynamic> json) =>
    ApplicantSaveRequest(
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['phoneNumber'] as String?,
      json['cityId'] as int?,
      json['description'] as String?,
      json['experience'] as String?,
       json['wageProposal'] == null
          ? null
          : Decimal.parse(json['wageProposal'] as String),
      json['cvFile'] == null ? null : base64Decode(json['cvFile'] as String),
      json['cvFileName'] as String?,
    );

Map<String, dynamic> _$ApplicantSaveRequestToJson(ApplicantSaveRequest instance) => <String, dynamic>{
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phoneNumber': instance.phoneNumber,
  'cityId': instance.cityId,
  'description': instance.description,
  'experience': instance.experience,
  'wageProposal': instance.wageProposal,
  'cvFile': instance.cvFile,
  'cvFileName': instance.cvFileName,
};