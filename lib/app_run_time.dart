import 'package:flutter/foundation.dart';

import 'model/log_entry.dart';

class AppRunTime {
  static final ValueNotifier<Map<String, LogEntry>> listLogNotifier =
      ValueNotifier(<String, LogEntry>{});

  static bool isShowLogInNotification = false;

  static void addLogToList(String key, LogEntry entry) {
    final next = Map<String, LogEntry>.from(listLogNotifier.value);
    next[key] = entry;
    listLogNotifier.value = next; // triggers listeners
  }

  static void clearLogEntries() {
    listLogNotifier.value = <String, LogEntry>{};
  }

  static void touch() {
    listLogNotifier.value =
        Map<String, LogEntry>.from(listLogNotifier.value); // immutable bump
  }
}
