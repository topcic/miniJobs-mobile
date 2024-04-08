import 'package:minijobs_admin/models/user_registration_response.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

class UserRegistrationProvider extends BaseProvider<UserRegistrationResponse> {
  UserRegistrationProvider(): super("users/registrations");
    @override
  UserRegistrationResponse fromJson(data) {
    return UserRegistrationResponse.fromJson(data);
  }
}