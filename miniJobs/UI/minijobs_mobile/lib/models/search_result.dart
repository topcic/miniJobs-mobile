import 'package:json_annotation/json_annotation.dart';

part 'search_result.g.dart';

@JsonSerializable()
class SearchResult<T> {
  int count;
  List<T>? result;

  SearchResult(this.count, this.result);

  factory SearchResult.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$SearchResultFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$SearchResultToJson(this, toJsonT);
}
