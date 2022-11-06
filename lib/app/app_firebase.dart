import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:picka/app/di/di.dart';
import 'package:picka/app/function.dart';
import 'package:picka/app/notification/app_notifications.dart';
import 'package:picka/app/notification/notificatin_model.dart';
import 'package:picka/data/storage/local/app_prefs.dart';
import 'package:picka/firebase_options.dart';

import 'constants.dart';

class AppFirebase {
  AppNotifications appNotifications = AppNotifications();

  static Future<AppFirebase> initializeFireBase() async {
    var init = AppFirebase();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await init.getFirebaseToken();
    await init.registerFCMBackgroundListener();
    await init.registerFCMForegroundListener();
    return init;
  }

  Future<void> getFirebaseToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    /// Requesting permission (Apple & Web)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: false,
      provisional: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    try {
      // use the returned token to send messages to users from your custom server
      String? token = await messaging.getToken(
        vapidKey: "BGpdLRs......",
      );
      dPrint("firebaseToken: ${token}");
      getIt<AppPreferences>().firebaseToken = token.toString();
      dPrint("firebaseToken11: ${ getIt<AppPreferences>().firebaseToken}");
    } catch (e) {
      print("getFirebaseTokenError: $e");
    }
  }

  Future<void> registerFCMBackgroundListener() async {
    try {
      FirebaseMessaging.onBackgroundMessage(
          _firebaseMessagingBackgroundHandler);
    } catch (e) {
      print("registerFCMBackgroundListenerError: $e");
    }
  }

  Future<void> registerFCMForegroundListener() async {
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // dPrint("message: ${message.toString()}");
        // print('Message data: ${message.data}');

        var notification = NotificationModel.fromJson(message.data);
        if (notification.imageUrl != null) {
          AppNotifications()
              .showBigPictureNotificationHiddenLargeIcon(notification);
        } else {
          AppNotifications().showNotification(notification);
        }
      });
    } catch (e) {
      print("registerFCMForegroundListenerError: $e");
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // dPrint("message: ${message}");
  // dPrint("Handling a background message: ${message.messageId}");
  print('Message data: ${message.data}');



  var notification = NotificationModel.fromJson(message.data);
  if (notification.imageUrl != null) {
    AppNotifications()
        .showBigPictureNotificationHiddenLargeIcon(notification);
  } else {
    AppNotifications().showNotification(notification);
  }
}

// String notificationUniqueIdId = "";
// void checkIfShowNotification(DataNotification dataNotification) async {
//   if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
//   if (Platform.isIOS) SharedPreferencesIOS.registerWith();
//   await CashHelper.init();
//   isEnglish = CashHelper.getData(CashHelper.LANG, DEFAULT_LANG) == "en";
//   print("checkIfShowNotification Start");
//   bool show = false;
//   String? stringValue =
//   CashHelper.getData(CashHelper.NOTIFICATION_SETTING, null);
//   var values = stringValue != null
//       ? Map<String, bool>.from(jsonDecode(stringValue))
//       : notificationSettingValues;
//
//   String eventType = dataNotification.notification!.eventType!;
//   String uniqueId = dataNotification.notification!.uniqueId!;
//   show = (values[eventType] ?? false) && values['silent']! == false&& notificationUniqueIdId!= uniqueId;
//
//   print(
//       "checkIfShowNotification eventType:$eventType  show:$show values[eventType]:${values[eventType]}");
//
//   if (show) {
//     notificationUniqueIdId = uniqueId;
//     if (dataNotification.notification!.imageUrl != null)
//       AppNotifications().showBigPictureNotificationHiddenLargeIcon(
//           dataNotification.notification!);
//     else {
//       print("ShowNotification eventType$eventType  show$show");
//       AppNotifications().showNotification(dataNotification.notification!);
//     }
//   }
// }
//
// class DataNotification {
//   String? priority;
//   String? bodyText;
//   String? contentAvailable;
//   String? type;
//   Notification? notification;
//
//   DataNotification(
//       {this.priority,
//         this.bodyText,
//         this.contentAvailable,
//         this.type,
//         this.notification});
//
//   DataNotification.fromJson(Map<String, dynamic> json) {
//     priority = json['priority'];
//     bodyText = json['bodyText'];
//     contentAvailable = json['content-available'];
//     type = json['type'];
//     notification = json['notification'] != null
//         ? new Notification.fromJson(jsonDecode(json['notification']))
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['priority'] = this.priority;
//     data['bodyText'] = this.bodyText;
//     data['content-available'] = this.contentAvailable;
//     data['type'] = this.type;
//     if (this.notification != null) {
//       data['notification'] = this.notification!.toJson();
//     }
//     return data;
//   }
// }
//
// class Notification {
//   String? messageAr;
//   String? titleAr;
//   String? uniqueId;
//   String? eventType;
//   int? matchId;
//   int? teamwayId;
//   String? messageEn;
//   String? titleEn;
//   int? hometeamId;
//   String? imageUrl;
//
//   String? get titleTr {
//     if (titleAr!.isEmpty||isEnglish)
//       return titleEn;
//     else
//       return titleAr;
//   }
//
//   String? get bodyTr {
//     if (messageAr!.isEmpty||isEnglish)
//       return messageEn;
//     else
//       return messageAr;
//   }
//
//   Notification(
//       {this.messageAr,
//         this.titleAr,
//         this.uniqueId,
//         this.eventType,
//         this.matchId,
//         this.teamwayId,
//         this.messageEn,
//         this.titleEn,
//         this.hometeamId});
//
//   Notification.fromJson(Map<String, dynamic> json) {
//     messageAr = json['message_ar'];
//     titleAr = json['title_ar'];
//     uniqueId = json['unique_id'];
//     eventType = json['event_type'];
//     matchId = json['match_id'];
//     teamwayId = json['teamway_id'];
//     messageEn = json['message_en'];
//     titleEn = json['title_en'];
//     hometeamId = json['hometeam_id'];
//     imageUrl = json['image_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['message_ar'] = this.messageAr;
//     data['title_ar'] = this.titleAr;
//     data['unique_id'] = this.uniqueId;
//     data['event_type'] = this.eventType;
//     data['match_id'] = this.matchId;
//     data['teamway_id'] = this.teamwayId;
//     data['message_en'] = this.messageEn;
//     data['title_en'] = this.titleEn;
//     data['hometeam_id'] = this.hometeamId;
//     data['image_url'] = this.imageUrl;
//     return data;
//   }
// }
