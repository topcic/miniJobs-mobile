import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class NotificationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // Show a success message
  void success(String message, {int lifeTime = 3}) {
    _showNotification(message, Colors.green, lifeTime);
  }

  // Show an informational message
  void info(String message, {int lifeTime = 3}) {
    _showNotification(message, Colors.blue, lifeTime);
  }

  // Show a warning message
  void warning(String message, {int lifeTime = 3}) {
    _showNotification(message, Colors.orange, lifeTime);
  }

  // Show an error message
  void error(String message, {int lifeTime = 3}) {
    _showNotification(message, Colors.red, lifeTime);
  }

  // Internal function to handle displaying a Flushbar with the specified color and lifetime
  void _showNotification(String message, Color backgroundColor, int lifeTime) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      Flushbar(
        message: message,
        duration: Duration(seconds: lifeTime),
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.all(8.0),
        borderRadius: BorderRadius.circular(8.0),
        icon: Icon(
          Icons.info_outline,
          color: Colors.white,
        ),
      )..show(context);
    } else {
      debugPrint('Error: No context available for NotificationService.');
    }
  }
}
