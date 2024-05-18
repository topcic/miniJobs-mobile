import 'package:minijobs_mobile/models/user.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class UserProvider extends BaseProvider<User> {
  UserProvider(): super("users");
    @override
  User fromJson(data) {
    return User.fromJson(data);
  }
}