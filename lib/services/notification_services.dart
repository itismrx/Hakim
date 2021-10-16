import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '/modal/case_modal.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = '123';

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    //  final IOSInitializationSettings initializationSettingsIOS =
    //     IOSInitializationSettings(
    //   requestSoundPermission: false,
    //   requestBadgePermission: false,
    //   requestAlertPermission: false,
    //   onDidReceiveLocalNotification: (){},
    // );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future selectNotification(String payload) {}

  void showNotification(int id, String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        id,
        'hakim',
        notificationMessage,
        const NotificationDetails(
            android: AndroidNotificationDetails(
          channel_id,
          'Hakim',
          'Uploading media...',
          priority: Priority.high,
        )),
        payload: notificationMessage);
  }

  void cancelNotificationForUpload(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  void cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
