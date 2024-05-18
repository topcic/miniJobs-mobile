// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map<String, dynamic> json) => City(
      json['id'] as int?,
      json['name'] as String?,
      json['countryId'] as int?,
      json['cantonId'] as int?,
      json['municipalityCode'] as String?,
      json['postCode'] as String?,
    );

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'countryId': instance.countryId,
      'cantonId': instance.cantonId,
      'municipalityCode': instance.municipalityCode,
      'postCode': instance.postCode,
    };
