import 'package:flutter/material.dart';
import 'package:logger_interceptor/app_run_time.dart';
import 'package:logger_interceptor/http_status_colors.dart';
import 'package:logger_interceptor/model/log_entry.dart';
import 'package:logger_interceptor/presentation/detail_screen.dart';

class ListAPIScreen extends StatefulWidget {
  @override
  State<ListAPIScreen> createState() => _ListAPIScreenState();
}

class _ListAPIScreenState extends State<ListAPIScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "List API",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              // clear log entries
              AppRunTime.clearLogEntries();
            },
          ),
        ],
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: AppRunTime.listLogNotifier,
              builder: (context, value, child) {
                List<MapEntry<String, LogEntry>> entries = [];
                entries = AppRunTime.listLogNotifier.value.entries
                    .toList()
                    .reversed
                    .toList();

                return RefreshIndicator(
                  onRefresh: () async {
                    AppRunTime.listLogNotifier.value =
                        Map<String, LogEntry>.from(
                            AppRunTime.listLogNotifier.value);
                    return;
                  },
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(height: 1),
                    ),
                    itemBuilder: (context, index) {
                      final entry = entries.elementAt(index);
                      LogEntry log = entry.value;
                      return ItemAPIWidget(log: log);
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class ItemAPIWidget extends StatelessWidget {
  final LogEntry log;

  const ItemAPIWidget({
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // navigate to detail screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailScreen(log: log),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Center(
              child: Text(
                '${log.response?.statusCode}',
                style: TextStyle(
                  color: HttpStatusColors.forStatus(log.response?.statusCode),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${log.request?.method.toUpperCase()} ${log.request?.path}",
                    style: TextStyle(
                      color:
                          HttpStatusColors.forStatus(log.response?.statusCode),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          log.formattedStart,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${log.duration}ms",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${log.responseSizeBytes}B",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
