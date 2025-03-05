// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      (json['countryId'] as num?)?.toInt(),
      json['municipalityCode'] as String?,
      json['postcode'] as String?,
      json['isDeleted'] as bool?,
      json['countryName'] as String?,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'countryId': instance.countryId,
      'municipalityCode': instance.municipalityCode,
      'postcode': instance.postcode,
      'isDeleted': instance.isDeleted,
    };
