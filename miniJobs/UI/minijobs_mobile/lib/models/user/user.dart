import 'dart:convert';
import 'dart:typed_data';
import 'package:json_annotation/json_annotation.dart';
import 'package:minijobs_mobile/models/city.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? role;
  bool? deleted;
  bool? accountConfirmed;
  Uint8List? photo;
  int? cityId;
  City? city;

  User(this.id, this.firstName, this.lastName, this.fullName, this.email,
      this.phoneNumber, this.role, this.deleted, this.accountConfirmed, this.photo,this.cityId,this.city);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
