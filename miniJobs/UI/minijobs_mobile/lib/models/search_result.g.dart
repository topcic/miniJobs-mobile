// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchResult<T> _$SearchResultFromJson<T>(
    Map<String, dynamic> json, T Function(Object? json) fromJsonT) {
  return SearchResult<T>(
    (json['count'] as num?)?.toInt() ?? 0,
    (json['result'] as List<dynamic>?)
        ?.map((e) => fromJsonT(e))
        .toList(),
  );
}

Map<String, dynamic> _$SearchResultToJson<T>(
    SearchResult<T> instance, Object Function(T value) toJsonT) {
  return <String, dynamic>{
    'count': instance.count,
    'result': instance.result?.map(toJsonT).toList(),
  };
}