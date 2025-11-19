import 'dart:convert';

import 'package:dio/dio.dart';
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
    if (log.request?.data != null) {
      if (log.request!.data is Map<String, dynamic>) {
        // requestBodyString = jsonEncode(log.request?.data);
        requestBodyString =
            const JsonEncoder.withIndent('  ').convert(log.request?.data);
      } else if (log.request!.data is FormData) {
        List<MapEntry<String, String>> fields =
            (log.request!.data as FormData).fields;
        List<MapEntry<String, MultipartFile>> files =
            (log.request!.data as FormData).files;

        Map<String, dynamic> formDataMap = {};
        if (fields.isNotEmpty) {
          for (var field in fields) {
            formDataMap[field.key] = field.value;
          }
        }

        if (files.isNotEmpty) {
          List<Map<String, dynamic>> fileList = [];
          for (var file in files) {
            fileList.add({
              'filename': file.value.filename,
              'contentType': file.value.contentType?.toString(),
              'length': file.value.length,
            });
          }
          formDataMap['files'] = fileList;
        }

        // requestBodyString = jsonEncode(formDataMap);
        requestBodyString =
            const JsonEncoder.withIndent('  ').convert(formDataMap);
      } else {
        requestBodyString = log.request?.data.toString() ?? '';
      }
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
            requestBodyString.isNotEmpty
                ? renderRowData(
                    'Request Body',
                    "\n$requestBodyString",
                  )
                : SizedBox.shrink(),
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
