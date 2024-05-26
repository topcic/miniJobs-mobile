// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_insert_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JobInsertRequest _$JobInsertRequestFromJson(Map<String, dynamic> json) =>
    JobInsertRequest(
      json['name'] as String?,
      json['description'] as String?,
      json['streetAddressAndNumber'] as String?,
      (json['cityId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$JobInsertRequestToJson(JobInsertRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'cityId': instance.cityId,
    };
