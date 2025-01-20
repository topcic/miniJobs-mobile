import 'package:json_annotation/json_annotation.dart';

part 'user_registration_response.g.dart';

@JsonSerializable()
class UserRegistrationResponse {
  bool? isRegistered;

  UserRegistrationResponse(this.isRegistered);

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) => _$UserRegistrationResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserRegistrationResponseToJson(this);
}
