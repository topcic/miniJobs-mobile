// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employer_save_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployerSaveRequest _$EmployerSaveRequestFromJson(Map<String, dynamic> json) =>
    EmployerSaveRequest(
      json['name'] as String?,
      json['streetAddressAndNumber'] as String?,
      json['idNumber'] as String?,
      json['companyPhoneNumber'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['phoneNumber'] as String?,
      json['cityId'] as int?,
    );

Map<String, dynamic> _$EmployerSaveRequestToJson(EmployerSaveRequest instance) => <String, dynamic>{
      'name': instance.name,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'idNumber': instance.idNumber,
      'companyPhoneNumber': instance.companyPhoneNumber,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'cityId': instance.cityId,
};