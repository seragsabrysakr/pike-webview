import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:picka/app/notification/notificatin_model.dart';
class AppNotifications{

  AppNotifications(){
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      // macOS: initializationSettingsMacOS,
      // linux: initializationSettingsLinux,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      //   onDidReceiveNotificationResponse: (NotificationResponse details) async {
      //     if (details.payload != null) {
      //       dPrint('notification payload: $details.payload');
      //     }
      //     // selectedNotificationPayload = payload;
      //     // selectNotificationSubject.add(payload);
      //   },
      // onDidReceiveBackgroundNotificationResponse: (NotificationResponse details) async {
      //     if (details.payload != null) {
      //       dPrint('notification Background payload : $details.payload');
      //     }
      //     // selectedNotificationPayload = payload;
      //     // selectNotificationSubject.add(payload);
      //   },
    );

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
  }

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsIOS =
  const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      // onDidReceiveLocalNotification: (
      //     int id,
      //     String? title,
      //     String? body,
      //     String? payload,
      //     ) async {
      //   didReceiveLocalNotificationSubject.add(
      //     ReceivedNotification(
      //       id: id,
      //       title: title,
      //       body: body,
      //       payload: payload,
      //     ),
      //   );
      // }
      );

  static const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('ic_stat_name');


  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> showNotification(NotificationModel notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();
    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(1000), notification.title, notification.body, platformChannelSpecifics,
        payload: 'item x');
  }

  Future<void> showBigPictureNotification() async {
    final String largeIconPath =await getImageFilePathFromAssets("assets/images/test_team_logo2.png") ;
    final String bigPicturePath =await getImageFilePathFromAssets("assets/images/stadium.png") ;
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<void> showBigPictureNotificationURL(NotificationModel notification) async {
    final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl(notification.imageUrl!));
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl(notification.imageUrl!));

    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(bigPicture,
        largeIcon: largeIcon,
        contentTitle: 'overridden <b>big</b> ${notification.title}',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>${notification.body}</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  Future<String> getImageFilePathFromAssets(String asset) async {
    final byteData = await rootBundle.load(asset);

    final file =
    File('${(await getTemporaryDirectory()).path}/${asset.split('/').last}');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file.path;
  }


  Future<void> showBigPictureNotificationHiddenLargeIcon(NotificationModel notification) async {
    final ByteArrayAndroidBitmap largeIcon = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl(notification.imageUrl!));
    final ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
        await _getByteArrayFromUrl(notification.imageUrl!));
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(bigPicture,
        hideExpandedLargeIcon: true,
        contentTitle: '${notification.title}',
        htmlFormatContentTitle: true,
        summaryText: '${notification.body}',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        largeIcon: largeIcon,
        styleInformation: bigPictureStyleInformation);
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        Random().nextInt(1000), '${notification.title}', '${notification.body}', platformChannelSpecifics);
  }

}