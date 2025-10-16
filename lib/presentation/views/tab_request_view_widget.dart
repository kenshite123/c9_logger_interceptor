import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:logger_interceptor/model/log_entry.dart';

class RequestViewWidget extends StatelessWidget {
  final LogEntry log;

  const RequestViewWidget({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, dynamic>> headers =
        log.request?.headers.entries.toList() ?? [];

    String requestBodyString = "";
    if (log.request?.data != null &&
        log.request!.data is Map<String, dynamic>) {
      requestBodyString = jsonEncode(log.request?.data);
    } else {
      requestBodyString = log.request?.data?.toString() ?? '';
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            renderRowData(
              'URL',
              "${log.request?.baseUrl}${log.request?.path}",
            ),
            SizedBox(height: 5),
            renderRowData(
              'Method',
              log.request?.method ?? '-',
            ),
            SizedBox(height: 5),
            renderRowData(
              'Request Time',
              log.formattedStart,
            ),
            for (var entry in headers) ...[
              const SizedBox(height: 5),
              renderRowData(entry.key, entry.value.toString()),
            ],
            SizedBox(height: 5),
            requestBodyString.isNotEmpty ? renderRowData(
              'Request Body',
              "\n$requestBodyString",
            ) : SizedBox.shrink(),
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
