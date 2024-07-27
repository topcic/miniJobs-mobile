// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Applicant _$ApplicantFromJson(Map<String, dynamic> json) => Applicant(
      (json['id'] as num?)?.toInt(),
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['userName'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['role'] as String?,
      json['deleted'] as bool?,
      json['accountConfirmed'] as bool?,
      json['photo'] == null ? null : base64Decode(json['photo'] as String),
      (json['cityId'] as num?)?.toInt(),
      json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      json['cv'] == null ? null : base64Decode(json['cv'] as String),
      json['description'] as String?,
      json['experience'] as String?,
      json['wageProposal'] == null
          ? null
          : Decimal.parse(json['wageProposal'] as String),
      json['jobType'] == null
          ? null
          : JobType.fromJson(json['jobType'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApplicantToJson(Applicant instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'deleted': instance.deleted,
      'accountConfirmed': instance.accountConfirmed,
      'photo': instance.photo == null ? null : base64Encode(instance.photo!),
      'cv': instance.cv == null ? null : base64Encode(instance.cv!),
      'city': instance.city,
      'cityId': instance.cityId,
      'description': instance.description,
      'experience': instance.experience,
      'wageProposal': instance.wageProposal,
      'jobType': instance.jobType,
    };
