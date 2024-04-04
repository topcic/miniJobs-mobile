import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minijobs_admin/models/auth_token_response.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

class AuthenticationProvider extends BaseProvider<AuthTokenResponse> {
  AuthenticationProvider() : super("tokens");
  @override
  AuthTokenResponse fromJson(data) {
    return AuthTokenResponse.fromJson(data);
  }

  Future<bool> tokens(String em, String ps) async {
    try {
      var url = baseUrl+"tokens";
      var uri = Uri.parse(url);

      var jsonRequest =
          jsonEncode({'email': em, 'password': ps, 'grantType': "password"});

      Response response = await post(uri,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonRequest);

      var data = jsonDecode(response.body);

      var result = fromJson(data);


      var tokenDecoded = JwtDecoder.decode(result.accessToken!);
      String? role;
      tokenDecoded.forEach((key, value) {
        if (key.endsWith('claims/role')) {
          GetStorage().write('role', value);
          role = value;
        } else if (key.endsWith('claims/nameidentifier')) {
          GetStorage().write('nameidentifier', value);
        } else if (key.endsWith('claims/givenname')) {
          GetStorage().write('givenname', value);
        } else if (key.endsWith('claims/surname')) {
          GetStorage().write('surname', value);
        } else if (key.endsWith('claims/emailaddress')) {
          GetStorage().write('emailaddress', value);
        }
      });
        GetStorage().write('accessToken', result.accessToken);
          GetStorage().write('refreshToken', result.refreshToken);
      return role == 'Administrator';
    } catch (e) {
      return false;
    }
  }
}
