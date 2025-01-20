import 'package:json_annotation/json_annotation.dart';
part 'auth_token_response.g.dart';

@JsonSerializable()
class AuthTokenResponse {
  String? accessToken;
  double? expiresIn;
  String? refreshToken;

  AuthTokenResponse(this.accessToken, this.expiresIn, this.refreshToken);

  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenResponseFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AuthTokenResponseToJson(this);
}
