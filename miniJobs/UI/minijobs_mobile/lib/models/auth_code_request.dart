import 'package:json_annotation/json_annotation.dart';

part 'auth_code_request.g.dart';

@JsonSerializable()

class AuthCodeRequest{
  String? email;
  String? password;
  late String grantType;
  String? refreshToken;
  String? authCode;

  AuthCodeRequest(this.email, this.password,this.grantType,this.refreshToken,this.authCode);

  factory AuthCodeRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthCodeRequestFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AuthCodeRequestToJson(this);
}