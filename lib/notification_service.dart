import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger_interceptor/app_run_time.dart';
import 'package:logger_interceptor/arr_ext.dart';
import 'package:logger_interceptor/model/log_entry.dart';
import 'package:logger_interceptor/presentation/list_api_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static GlobalKey<NavigatorState>? _navigatorKey;
  static String? _pendingPayload;
  static const channelId = 'c9_logger_channel';
  static const channelName = 'C9 Logger Channel';
  static const channelDescription = 'Used for general notifications';
  static const groupKey = 'com.example.apiLogs';
  static const apiLogPayload = 'api_log_payload';
  static String? _androidNotificationIcon;

  @pragma('vm:entry-point')
  static void _notificationTapBackground(NotificationResponse response) {
    NotificationService._storeBackgroundPayload(response.payload);
  }

  static void _storeBackgroundPayload(String? payload) {
    if (payload != null) {
      _pendingPayload = payload;
    }
  }

  static void processLaunchPayload() {
    if (_pendingPayload != null) {
      final payload = _pendingPayload;
      _pendingPayload = null;
      _handlePayload(payload);
    }
  }

  static Future<bool> isHaveNotificationPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.notification.status;
      return status.isGranted;
    } else if (Platform.isIOS) {
      final plugin = FlutterLocalNotificationsPlugin();
      final ios = plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final settings = await ios?.checkPermissions();
      return settings?.isEnabled == true;
    }
    return false;
  }

  static Future<void> requestNotificationPermission() async {
    if (await isHaveNotificationPermission()) {
      return;
    }

    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.notification.status;

      if (status.isDenied) {
        status = await Permission.notification.request();
      }
    } else if (Platform.isIOS) {
      final plugin = FlutterLocalNotificationsPlugin();
      final ios = plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      await ios?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    String? androidNotificationIcon,
  }) async {
    _navigatorKey = navigatorKey;
    _androidNotificationIcon = androidNotificationIcon;

    await requestNotificationPermission();

    final androidInit = AndroidInitializationSettings(
        _androidNotificationIcon ?? '@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handlePayload(response.payload);
      },
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );

    final launchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      _pendingPayload = launchDetails!.notificationResponse?.payload;
    }
  }

  static Future<void> showNotificationForLogger(LogEntry logEntry) async {
    if (!await isHaveNotificationPermission()) {
      return;
    }
    await showNotification(
      id: 1,
      title: "${logEntry.request?.method}: ${logEntry.request?.path}",
      body:
          "Status: ${logEntry.response?.statusCode} - ${logEntry.response?.statusMessage}",
      payload: apiLogPayload,
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    List<String> lines = AppRunTime.listLogNotifier.value.entries
        .toList()
        .filter((e) => !e.value.isRead)
        .map((e) => "${e.value.request?.method}: ${e.value.request?.path}")
        .toList();

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      groupKey: groupKey,
      setAsGroupSummary: lines.length > 1,
      styleInformation: lines.length > 1
          ? InboxStyleInformation(
              lines,
              contentTitle: 'You have ${lines.length} new items',
              summaryText: 'Tap to view all items',
            )
          : null,
    );

    final iosDetails = DarwinNotificationDetails(
      presentBanner: false,
      presentBadge: false,
      presentList: true,
      threadIdentifier: groupKey,
    );

    NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  static void _handlePayload(String? payload) {
    if (payload == null) return;
    if (payload == apiLogPayload) {
      AppRunTime.listLogNotifier.value.entries
          .toList()
          .filter((e) => !e.value.isRead)
          .forEach((element) => element.value.isRead = true);

      _navigatorKey?.currentState?.push(
        MaterialPageRoute(
          builder: (context) => ListAPIScreen(),
        ),
      );
    }
  }
}
