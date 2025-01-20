import 'package:json_annotation/json_annotation.dart';

part 'user_change_password_request.g.dart';

@JsonSerializable()
class UserChangePasswordRequest {
  String authCode;
  String newPassword;
  UserChangePasswordRequest(
      this.authCode,
      this.newPassword);


  Map<String, dynamic> toJson() => _$UserChangePasswordRequestToJson(this);
}