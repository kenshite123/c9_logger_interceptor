import 'package:flutter/material.dart';
import 'package:logger_interceptor/model/log_entry.dart';
import 'package:logger_interceptor/presentation/views/tab_overview_widget.dart';
import 'package:logger_interceptor/presentation/views/tab_request_view_widget.dart';
import 'package:logger_interceptor/presentation/views/tab_response_view_widget.dart';

class DetailScreen extends StatefulWidget {
  final LogEntry log;

  const DetailScreen({
    super.key,
    required this.log,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "${widget.log.request?.method} ${widget.log.request?.path}",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: DefaultTabController(
            length: 3,
            initialIndex: 0,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  child: TabBar(
                    indicatorColor: Color(0xff007bc0),
                    labelColor: Color.fromRGBO(0, 127, 194, 1),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    unselectedLabelColor: Colors.black,
                    labelPadding: EdgeInsets.symmetric(horizontal: 5),
                    unselectedLabelStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    tabs: [
                      Tab(
                        icon: Icon(Icons.info_outlined),
                        iconMargin: EdgeInsets.only(bottom: 5),
                        text: "Overview",
                      ),
                      Tab(
                        icon: Icon(Icons.arrow_upward_outlined),
                        iconMargin: EdgeInsets.only(bottom: 5),
                        text: "Request",
                      ),
                      Tab(
                        icon: Icon(Icons.arrow_downward_outlined),
                        iconMargin: EdgeInsets.only(bottom: 5),
                        text: "Response",
                      ),
                      // Tab(
                      //   icon: Icon(Icons.error_outline_outlined),
                      //   iconMargin: EdgeInsets.only(bottom: 5),
                      //   text: "Error",
                      // ),
                    ],
                  ),
                ),
                const Divider(
                  height: 2,
                  color: Color.fromRGBO(0, 0, 0, 0.2),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      OverviewWidget(log: widget.log),
                      RequestViewWidget(log: widget.log),
                      ResponseViewWidget(log: widget.log),
                      // SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
