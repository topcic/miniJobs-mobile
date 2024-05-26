// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['id'] as num?)?.toInt(),
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['userName'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['role'] as String?,
      json['deleted'] as bool?,
      json['accountConfirmed'] as bool?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'deleted': instance.deleted,
      'accountConfirmed': instance.accountConfirmed,
    };
