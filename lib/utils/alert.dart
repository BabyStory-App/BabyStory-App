import 'package:flutter/material.dart';

class SelectionItem<T> {
  final String name;
  final T value;

  SelectionItem({required this.name, required this.value});
}

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
    Future<void> Function()? onAccept,
    Future<void> Function()? onCancel,
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

  static Future<T?> selectionAlert<T>({
    required BuildContext context,
    required String title,
    required String content,
    required List<SelectionItem<T>> items,
    String closeText = '취소',
    Future<void> Function()? onClose,
  }) async {
    return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(content),
              const SizedBox(height: 16.0),
              Column(
                children: items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    onTap: () {
                      Navigator.of(context).pop(item.value);
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(closeText, style: const TextStyle(color: Colors.red)),
              onPressed: () async {
                if (onClose != null) {
                  await onClose();
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
