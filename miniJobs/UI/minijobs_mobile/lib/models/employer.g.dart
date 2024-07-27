// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employer _$EmployerFromJson(Map<String, dynamic> json) => Employer(
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
      json['name'] as String?,
      json['streetAddressAndNumber'] as String?,
      json['idNumber'] as String?,
      json['companyPhoneNumber'] as String?,
    );

Map<String, dynamic> _$EmployerToJson(Employer instance) => <String, dynamic>{
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
      'city': instance.city,
      'cityId': instance.cityId,
      'name': instance.name,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'idNumber': instance.idNumber,
      'companyPhoneNumber': instance.companyPhoneNumber,
    };
