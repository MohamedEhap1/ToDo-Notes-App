import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static onTap(NotificationResponse notificationResponse) {}
  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/launcher_icon'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
  }

  //basic NOtification [Done]
  static void showBasicNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'id 1',
        'basic notification',
        importance: Importance.max, //to show the notification on top of app
        priority: Priority.max,
      ),
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'Basic Notification',
      'You have task ToDo',
      notificationDetails,
      payload: 'payload Data',
    );
  }

//repeated Notifications
  static void showRepeatedNotification() async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'id 2',
        'Repeated notification',
        importance: Importance.max, //to show the notification on top of app
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound(
          "sound.mp3".split('.').first,
        ),
      ),
    );
    await flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      'Repeated Notification',
      'صلي على محمد',
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: 'payload Data',
    );
  }

//cancel Notification
  static void cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  //cancel All Notifications
  static void cancelAllNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

//ScheduledNotifications
  static void showScheduledNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'id 3', 'Repeated notification',
        importance: Importance.max, //to show the notification on top of app
        priority: Priority.max,
      ),
    );
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(
      tz.getLocation(currentTimeZone),
    );
    var currentTime = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, currentTime.year,
        currentTime.month, currentTime.day, currentTime.hour, 11, 5);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      // If the scheduled date is in the past, show an error or adjust it accordingly
      log('Scheduled date must be in the future');
      return;
    }
    log(tz.TZDateTime.now(tz.local).hour.toString());
    log(tz.TZDateTime.now(tz.local).minute.toString());
    log(tz.TZDateTime.now(tz.local).second.toString());

    await flutterLocalNotificationsPlugin.zonedSchedule(
        2, 'Scheduled Notification', 'body', scheduledDate, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static void showDailyScheduledNotification() async {
    NotificationDetails notificationDetails = const NotificationDetails(
      android: AndroidNotificationDetails(
        'id 3', 'Daily Scheduled notification',
        importance: Importance.max, //to show the notification on top of app
        priority: Priority.max,
      ),
    );
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(
      tz.getLocation(currentTimeZone),
    );
    var currentTime = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
        tz.local, currentTime.year, currentTime.month, currentTime.day, 21);
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      scheduledDate = scheduledDate.add(
        const Duration(days: 1),
      );
      // If the scheduled date is in the past, show an error or adjust it accordingly
      log('Scheduled date must be in the future');
      return;
    }
    log(tz.TZDateTime.now(tz.local).hour.toString());
    log(tz.TZDateTime.now(tz.local).minute.toString());
    log(tz.TZDateTime.now(tz.local).second.toString());

    await flutterLocalNotificationsPlugin.zonedSchedule(3, 'ToDo Notes App',
        'you have tasks to complete now', scheduledDate, notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}

        // tz.TZDateTime.now(tz.local).add(
        //   const Duration(seconds: 10),
        // ),