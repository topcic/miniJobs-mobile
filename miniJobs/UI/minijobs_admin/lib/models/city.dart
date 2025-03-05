import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

@JsonSerializable()
class City {
  int? id;
  String? name;
  int? countryId;
  String? municipalityCode;
  String? postcode;
  bool? isDeleted;
  String? countryName;


  City(this.id, this.name, this.countryId, this.municipalityCode,
      this.postcode,this.isDeleted,this.countryName);

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);

  Map<String, dynamic> toJson() => _$CityToJson(this);
}
