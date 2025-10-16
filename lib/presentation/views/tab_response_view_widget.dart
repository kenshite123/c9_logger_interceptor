import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger_interceptor/model/log_entry.dart';

class ResponseViewWidget extends StatelessWidget {
  final LogEntry log;

  const ResponseViewWidget({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    String cacheControl = log.response?.headers.value('cache-control') ?? '';
    String contentType = log.response?.headers.value('content-type') ?? '';

    String responseData = "";
    if (log.response?.data != null &&
        log.response!.data is Map<String, dynamic>) {
      responseData = jsonEncode(log.response?.data);
    } else {
      responseData = log.response?.data?.toString() ?? '';
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderRowData(
              'Response',
              "${log.response?.statusCode} ${log.response?.statusMessage}",
            ),
            SizedBox(height: 5),
            renderRowData(
              'Response Time',
              log.formattedEnd,
            ),
            SizedBox(height: 5),
            renderRowData(
              'Duration',
              "${log.duration}ms",
            ),
            SizedBox(height: 5),
            renderRowData(
              'Content Type',
              contentType,
            ),
            SizedBox(height: 5),
            renderRowData(
              'Cache-Control',
              cacheControl,
            ),
            SizedBox(height: 5),
            renderRowData(
              'Response Data',
              "\n$responseData",
            ),
          ],
        ),
      ),
    );
  }

  Widget renderRowData(String title, String value) {
    return SelectableText.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
