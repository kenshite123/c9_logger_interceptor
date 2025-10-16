import 'package:flutter/material.dart';

class HttpStatusColors {
  static Color forStatus(int? code) {
    if (code == null || code == 0) return Colors.grey;

    if (code >= 100 && code < 200) return Colors.blueGrey;          // 1xx
    if (code >= 200 && code < 300) return Colors.green.shade600;     // 2xx
    if (code >= 300 && code < 400) return Colors.amber.shade700;     // 3xx
    if (code >= 400 && code < 500) return Colors.deepOrangeAccent;   // 4xx
    if (code >= 500 && code < 600) return Colors.redAccent;          // 5xx

    return Colors.grey;
  }
}