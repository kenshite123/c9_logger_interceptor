import 'dart:io';

import 'package:flutter/material.dart';
import 'package:logger_interceptor/app_run_time.dart';
import 'package:logger_interceptor/notification_service.dart';
import 'package:path_provider/path_provider.dart';

class C9 {
  String get className => 'C9';

  static Future<void> initialize({
    required GlobalKey<NavigatorState> navigatorKey,
    bool isShowLogInNotification = false,
    String? androidNotificationIcon,
  }) async {
    await _resolveLogDirectory(create: true);

    AppRunTime.isShowLogInNotification = isShowLogInNotification;
    if (isShowLogInNotification) {
      await NotificationService.initialize(
        navigatorKey: navigatorKey,
        androidNotificationIcon: androidNotificationIcon,
      );
    }
  }

  static Future<Directory> _resolveLogDirectory({bool create = false}) async {
    final baseDir = await getApplicationSupportDirectory();
    final dir = Directory('${baseDir.path}/logs/api');
    if (create && !await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<List<File>> getListLogFiles() async {
    final logDirectory = await _resolveLogDirectory();
    if (!await logDirectory.exists()) {
      return [];
    }
    final entities = await logDirectory.list().toList();
    return entities.whereType<File>().map((e) => File(e.path)).toList();
  }
}
