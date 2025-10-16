import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class LogEntry {
  DateTime? start;
  DateTime? end;
  RequestOptions? request;
  Response? response;
  DioException? error;
  bool isRead = false;

  @override
  String toString() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    DateTime start = this.start ?? DateTime.now();
    DateTime end = this.end ?? DateTime.now();
    final String startTimeFormatted = dateFormat.format(start);
    final String endTimeFormatted = dateFormat.format(end);
    final int duration = end.difference(start).inMilliseconds;

    String requestBody;
    try {
      if (request?.data == null) {
        requestBody = 'null';
      } else if (request?.data is String) {
        requestBody = request?.data as String;
      } else {
        requestBody = jsonEncode(request?.data);
      }
    } catch (e) {
      requestBody = request?.data.toString() ?? 'null';
    }

    String responseBody;
    try {
      if (response?.data == null) {
        responseBody = 'null';
      } else if (response?.data is String) {
        responseBody = response?.data as String;
      } else {
        responseBody = jsonEncode(response?.data);
      }
    } catch (e) {
      responseBody = response?.data.toString() ?? 'null';
    }

    String headersString;
    try {
      headersString = jsonEncode(request?.headers);
    } catch (e) {
      headersString = request?.headers.toString() ?? 'null';
    }

    String logAPI =
        '''\n
$startTimeFormatted: Request API
URL: ${request?.baseUrl}${request?.path}
Method: ${request?.method}
Headers: $headersString
Body: $requestBody
Start Time: $startTimeFormatted
End Time: $endTimeFormatted
Duration: $duration ms
Response Code: ${response?.statusCode ?? -1}
Response Message: ${response?.statusMessage ?? error?.message ?? 'No message'}
Response Body: $responseBody
''';
    return logAPI;
  }

  int get duration {
    if (start != null && end != null) {
      return end!.difference(start!).inMilliseconds;
    }
    return 0;
  }

  String get formattedStart => DateFormat('yyyy-MM-dd HH:mm:ss').format(start ?? DateTime.now());
  String get formattedEnd => DateFormat('yyyy-MM-dd HH:mm:ss').format(end ?? DateTime.now());

  int get requestSizeBytes {
    final data = request?.data;
    if (data == null) return 0;
    if (data is List<int>) return data.length;
    return utf8.encode(data is String ? data : data.toString()).length;
  }

  int get responseSizeBytes {
    final data = response?.data;
    if (data == null) return 0;
    if (data is List<int>) return data.length;
    return utf8.encode(data is String ? data : data.toString()).length;
  }
}
