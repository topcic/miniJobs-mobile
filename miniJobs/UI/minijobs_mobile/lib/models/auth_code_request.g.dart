// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthCodeRequest _$AuthCodeRequestFromJson(Map<String, dynamic> json) =>
    AuthCodeRequest(
      json['email'] as String?,
      json['password'] as String?,
      json['grantType'] as String,
      json['refreshToken'] as String?,
      json['authCode'] as String?,
    );

Map<String, dynamic> _$AuthCodeRequestToJson(AuthCodeRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'grantType': instance.grantType,
      'refreshToken': instance.refreshToken,
      'authCode': instance.authCode,
    };
