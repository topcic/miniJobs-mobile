// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job(
      json['id'] as int?,
      json['name'] as String?,
      json['description'] as String?,
      json['streetAddressAndNumber'] as String?,
      json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      json['applicationsEndTo'] == null
          ? null
          : DateTime.parse(json['applicationsEndTo'] as String),
      json['status'] as int?,
      json['requiredEmployees'] as int?,
      json['wage'] as int?,
      json['employer'] == null
          ? null
          : Employer.fromJson(json['employer'] as Map<String, dynamic>),
      json['state'] as int?,
    );

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'city': instance.city,
      'applicationsEndTo': instance.applicationsEndTo?.toIso8601String(),
      'status': instance.status,
      'requiredEmployees': instance.requiredEmployees,
      'wage': instance.wage,
      'employer': instance.employer,
      'state': instance.state,
    };
