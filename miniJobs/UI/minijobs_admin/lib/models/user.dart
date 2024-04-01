import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? firstName;
  String? lastName;
  String? userName;
  String? email;
  String? phoneNumber;
  String? role;
  bool? deleted;
  bool? accountConfirmed;

  User(this.id, this.firstName, this.lastName, this.userName, this.email,
      this.phoneNumber, this.role, this.deleted, this.accountConfirmed);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
