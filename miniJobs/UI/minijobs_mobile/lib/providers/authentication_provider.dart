import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:minijobs_mobile/models/auth_code_request.dart';
import 'package:minijobs_mobile/models/auth_token_response.dart';
import 'package:minijobs_mobile/pages/auth/login_sign_up_page.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';


class AuthenticationProvider extends BaseProvider<AuthTokenResponse> {
  AuthenticationProvider() : super("tokens");
  @override
  AuthTokenResponse fromJson(data) {
    return AuthTokenResponse.fromJson(data);
  }

  Future<bool?> tokens(AuthCodeRequest request) async {
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
        return false;
      }

      var tokenDecoded = JwtDecoder.decode(result.accessToken!);

      // Check the role before proceeding
      String? role;
      tokenDecoded.forEach((key, value) {
        if (key.endsWith('claims/role')) {
          role = value;
        }
      });

      // If role is neither "Applicant" nor "Employer," return null
      if (role != "Applicant" && role != "Employer") {
        return null;
      }

      // If role is "Applicant" or "Employer," proceed with writing to storage
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
        MaterialPageRoute(builder: (context) => const LoginSignupPage()),
            (route) => false, // Removes all previous routes
      );
    } catch (e) {
      print('Error during logout: $e');
    }
  }
}

