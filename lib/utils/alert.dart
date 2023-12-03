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

  static Future<void> alert({
    required BuildContext context,
    required String title,
    required String content,
    Function? onAccept,
  }) async {
    onAccept ??= (() async {});

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
              onPressed: () async {
                onAccept!().then((value) {
                  Navigator.pop(context);
                });
              },
            )
          ],
        );
      },
    );
  }

  static Future<void> confirmAlert({
    required BuildContext context,
    required String title,
    required String content,
    Function? onAccept,
    Function? onCancel,
    String acceptText = '확인',
    String cancelText = '취소',
  }) async {
    onAccept ??= (() async {});
    onCancel ??= (() async {});

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(cancelText),
              onPressed: () async {
                onCancel!().then((value) {
                  Navigator.pop(context);
                });
              },
            ),
            TextButton(
              child: Text(acceptText),
              onPressed: () async {
                onAccept!().then((value) {
                  Navigator.pop(context);
                });
              },
            )
          ],
        );
      },
    );
  }
}
