import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {
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

  // Internal function to handle displaying a toast with the specified color and lifetime
  void _showNotification(String message, Color backgroundColor, int lifeTime) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: lifeTime > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: lifeTime,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
