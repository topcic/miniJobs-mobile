
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/navbar.dart';

class AuthHelper {
  static void checkIsAuthenticated(BuildContext context) {
    final String? accessToken = GetStorage().read('accessToken');

    if (accessToken != null && accessToken.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Navbar()),
        );
      });
    }
  }
}