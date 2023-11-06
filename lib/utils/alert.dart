import 'package:flutter/material.dart';

class Alert {
  static bool show(BuildContext context, String message, Function? condition) {
    if (condition != null && condition() == false) return false;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
    return true;
  }
}
