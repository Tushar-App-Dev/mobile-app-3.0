// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// class NotificationApi{
//   static final _notifications = FlutterLocalNotificationsPlugin();
//
//   static Future _notificationDetails() async{
//    return const NotificationDetails(
//      android: AndroidNotificationDetails(
//        'channel id',
//        'channel name',
//        channelDescription: 'channel description',
//        importance: Importance.max
//      ),
//      iOS: IOSNotificationDetails(),
//    );
//   }
//   static Future showScheduledNotification({
//   int id=0,
//     String title,
//     String body,
//     String payload,
//     DateTime scheduledate,
// })
//   async=>
//       _notifications.zonedSchedule(
//         id,
//         title,
//         body,
//         tz.TZDateTime.from(scheduledate,tz.local),
//         await _notificationDetails(),
//         payload:payload,
//           androidAllowWhileIdle: true,
//           uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
//       );
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void sendNotification({String title, String body, RepeatInterval repeatInterval}) async {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ////Set the settings for various platform
  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS =
  IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );
  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  ///
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_channel', 'High Importance Notification',
      description: "This channel is for important notification",
      importance: Importance.max);

  flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    title,
    body,
    repeatInterval,
    NotificationDetails(
      android: AndroidNotificationDetails(channel.id, channel.name,
          channelDescription: channel.description),
      iOS: const IOSNotificationDetails(),
    ),
  );
}