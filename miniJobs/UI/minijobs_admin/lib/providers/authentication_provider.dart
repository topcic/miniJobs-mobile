import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minijobs_admin/models/auth_code_request.dart';
import 'package:minijobs_admin/models/auth_token_response.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

import '../pages/auth/login_page.dart';


class AuthenticationProvider extends BaseProvider<AuthTokenResponse> {
  AuthenticationProvider() : super("tokens");
  @override
  AuthTokenResponse fromJson(data) {
    return AuthTokenResponse.fromJson(data);
  }

  Future<bool> tokens(AuthCodeRequest request) async {
    try {
      var url = "${baseUrl}tokens";
      var dio = Dio();

      var jsonRequest = jsonEncode({
        'email': request.email,
        'password': request.password,
        'grantType': request.grantType,
        'authcode': request.authCode,
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

      // Ensure result.accessToken is not null
      if (result.accessToken == null) {
        print('Error: Access token is null');
        return false;
      }

      var tokenDecoded = JwtDecoder.decode(result.accessToken!);

      tokenDecoded.forEach((key, value) {
        if (key.endsWith('claims/role')) {
          GetStorage().write('role', value);
        } else if (key.endsWith('claims/nameidentifier')) {
          GetStorage().write('userId', value);
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
      // Log the error for debugging
      print('Error: $e');
      return false;
    }
  }
  void logout(BuildContext context) {
    try {
      // Clear all stored data
      GetStorage().erase();

      // Navigate to the LoginPage and clear the navigation stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false, // Removes all previous routes
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}

