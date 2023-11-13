import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidInitializationSettings initializationSettingsAndroid;
  late InitializationSettings initializationSettings;
  late AndroidNotificationDetails androidPlatformChannelSpecifics;
  late NotificationDetails platformChannelSpecifics;

  NotificationService({String notiIcon = '@mipmap/launcher_icon'}) {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // 화면에 보이는 아이콘 설정.
    initializationSettingsAndroid = AndroidInitializationSettings(notiIcon);
    initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'baby_7701',
      'baby_cry_detection',
      importance: Importance.max,
      priority: Priority.high,
    );
    platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  showNotification(String title, String desc) async {
    await flutterLocalNotificationsPlugin.show(
      7701,
      title,
      desc,
      platformChannelSpecifics,
    );
  }
}
