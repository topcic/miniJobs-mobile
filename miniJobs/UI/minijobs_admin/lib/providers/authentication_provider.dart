import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minijobs_admin/models/auth_code_request.dart';
import 'package:minijobs_admin/models/auth_token_response.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

class AuthenticationProvider extends BaseProvider<AuthTokenResponse> {
  AuthenticationProvider() : super("tokens");
  @override
  AuthTokenResponse fromJson(data) {
    return AuthTokenResponse.fromJson(data);
  }

  Future<bool> tokens(AuthCodeRequest request) async {
    try {
       var url = baseUrl + "tokens";

    var dio = Dio(); // Create Dio instance

    var jsonRequest = jsonEncode({
      'email': request.email,
      'password': request.password,
      'grantType': request.grantType,
      'authcode': request.authCode
    });

    var response = await dio.post(
      url,
      data: jsonRequest,
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

   var result = fromJson(response.data);

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
      return true;
    } catch (e) {
      return false;
    }
  }
}
