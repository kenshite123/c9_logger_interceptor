import 'package:flutter/material.dart';
import 'package:logger_interceptor/model/log_entry.dart';

class OverviewWidget extends StatelessWidget {
  final LogEntry log;

  const OverviewWidget({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    int requestSize = log.requestSizeBytes;
    int responseSize = log.responseSizeBytes;
    int totalSize = requestSize + responseSize;

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
              'SSL',
              (log.request?.baseUrl.startsWith("https") == true) ? "Yes" : "No",
            ),
            SizedBox(height: 5),
            renderRowData(
              'Response',
              "${log.response?.statusCode} ${log.response?.statusMessage}",
            ),
            SizedBox(height: 5),
            renderRowData(
              'Request Time',
              log.formattedStart,
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
              'Request Size',
              "${requestSize}B",
            ),
            SizedBox(height: 5),
            renderRowData(
              'Response Size',
              "${responseSize}B",
            ),
            SizedBox(height: 5),
            renderRowData(
              'Total Size',
              "${totalSize}B",
            ),
          ],
        ),
      ),
    );
  }

  Widget renderRowData(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Text(
            '$title: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SelectableText(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
