import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:logger_interceptor/app_run_time.dart';
import 'package:logger_interceptor/notification_service.dart';
import 'package:path_provider/path_provider.dart';

import 'model/log_entry.dart';

class LoggerInterceptor extends InterceptorsWrapper {
  static int _seq = 0;

  static String _nextKey(RequestOptions o) {
    final ts = DateTime.now().microsecondsSinceEpoch;
    final s = ++_seq;
    return '${ts}_${s}_${o.method}_${o.path}';
  }

  static const _extraKey = 'log_key';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final key = _nextKey(options);
    options.extra[_extraKey] = key;
    AppRunTime.addLogToList(
      key,
      LogEntry()
        ..start = DateTime.now()
        ..request = options,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final key = response.requestOptions.extra[_extraKey] as String?;
    if (key != null) {
      final log = AppRunTime.listLogNotifier.value[key];
      if (log != null) {
        log.end = DateTime.now();
        log.response = response;
        AppRunTime.touch();
        scheduleMicrotask(() => _handleLogger(key));
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final key = err.requestOptions.extra[_extraKey] as String?;
    if (key != null) {
      final log = AppRunTime.listLogNotifier.value[key];
      if (log != null) {
        log.end = DateTime.now();
        log.response = err.response;
        log.error = err;
        AppRunTime.touch();
        scheduleMicrotask(() => _handleLogger(key));
      }
    }
    super.onError(err, handler);
  }

  Future<void> _writeLog(LogEntry logEntry) async {
    try {
      final logDirPath = await getApplicationSupportDirectory();
      final String folderLogFile = "${logDirPath.path}/logs/api";
      final logDirectory = Directory(folderLogFile);

      if (!await logDirectory.exists()) {
        await logDirectory.create(recursive: true);
      }

      String dateWriteLog = DateFormat('yyyy_MM_dd').format(DateTime.now());
      final String logFilePath = "$folderLogFile/log_api_$dateWriteLog.log";
      final file = File(logFilePath);
      await file.writeAsString(logEntry.toString(), mode: FileMode.append);
    } catch (e) {
      print('Failed to save crash log to file: $e');
    }
  }

  Future<dynamic> _handleLogger(String key) async {
    if (AppRunTime.isShowLogInNotification) {
      LogEntry? logEntry = AppRunTime.listLogNotifier.value[key];
      if (logEntry != null) {
        NotificationService.showNotificationForLogger(logEntry);
        _writeLog(logEntry);
      }
    }
  }
}
