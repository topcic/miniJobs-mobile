// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employer _$EmployerFromJson(Map<String, dynamic> json) => Employer(
      json['id'] as int?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['userName'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['role'] as String?,
      json['deleted'] as bool?,
      json['accountConfirmed'] as bool?,
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
      'name': instance.name,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'idNumber': instance.idNumber,
      'companyPhoneNumber': instance.companyPhoneNumber,
    };
