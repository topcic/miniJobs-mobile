import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  int? id;
  String? name;
  int? countryId;
  int? cantonId;
  String? municipalityCode;
  String? postCode;

  City(this.id, this.name, this.countryId, this.cantonId, this.municipalityCode,
      this.postCode);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
