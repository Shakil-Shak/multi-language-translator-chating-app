import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:multi_language_firebase_chat_app/models/UserModel.dart';

import 'FirebaseHelper.dart';

class NotificationModel {
  static final serverKey =
      'AAAAwSMZbz8:APA91bHOURkXgB9kn3LbJKQyCNbz9n0_YsMc6Nwgf-pdhF7-cl7QKAxzwhWD-ByXgHoGm8Hm1xaIaWys1TCvtkuI_HL3piGmYN_H37VqSYAtY0duZ4g_-vzGUrs1TeQlz9H3J1HLGfCy';
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize =
        new AndroidInitializationSettings('mipmap/ic_launcher');
    var iOSInitialize = new DarwinInitializationSettings();
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings);
  }

  static Future showBigTextNotification(
    
      {var id = 0,
       var title,
      required RemoteMessage message,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
      'you_can_name_it_whatever1',
      'channel_name',

      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
    );

    var not = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: DarwinNotificationDetails());
    await fln.show(0, message.notification!.title, message.notification!.body, not);
  }

  static Future<void> sendNotification(
      {String? title, String? message, String? token}) async {
    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      'message': message
    };

    try {
      http.Response r = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': data,
            "to": "$token"
          },
        ),
      );
    } catch (e) {
      log('exception $e');
    }
  }

  static storeToken() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    UserModel? userModel =
        await FirebaseHelper.getUserModelById(currentUser!.uid);
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      userModel!.fcmToken = token;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userModel.uid)
          .set(userModel.toMap());
      // .collection('users')
      // .doc(FirebaseAuth.instance.currentUser!.uid)
      // .set({'fcmToken': token!}, SetOptions(merge: true));

    } catch (e) {
      print("error is $e");
    }
  }
  // static final notifications = FlutterLocalNotificationsPlugin();

  // static Future notificationDetails() async {
  //   return NotificationDetails(
  //     android: AndroidNotificationDetails('channel id', 'channel name',
  //         channelDescription: 'channel description',
  //         importance: Importance.max),
  //     iOS: DarwinNotificationDetails(),
  //   );
  // }

  // static Future showNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payload,
  // }) async {
  //   notifications.show(id, title, body, await notificationDetails(),
  //       payload: payload);
  // }

}
