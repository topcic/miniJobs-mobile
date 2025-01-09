// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      (json['id'] as num?)?.toInt(),
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['fullName'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['role'] as String?,
      json['deleted'] as bool?,
      json['accountConfirmed'] as bool?,
      json['photo'] == null ? null : base64Decode(json['photo'] as String),
       (json['cityId'] as num?)?.toInt(),
       json['city'] == null
          ? null
          : City.fromJson(
              json['city'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'deleted': instance.deleted,
      'accountConfirmed': instance.accountConfirmed,
      'photo': instance.photo == null ? null : base64Encode(instance.photo!),
    };
