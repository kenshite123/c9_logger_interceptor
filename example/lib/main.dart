import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger_interceptor/c9.dart';
import 'package:logger_interceptor/presentation/list_api_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // FlutterError.onError = (FlutterErrorDetails details) {
  //   // Default behavior (print to console)
  //   FlutterError.dumpErrorToConsole(details);
  //
  //   // Custom logging
  //   print("Flutter error: ${details.exceptionAsString()}\n${details.stack}");
  // };

  runApp(const MyApp());

  await Logger.initialize(
    isShowLogInNotification: true,
    navigatorKey: navigatorKey,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://httpbin.org',
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
        sendTimeout: Duration(seconds: 60),
      ),
    );

    dio.interceptors.add(LoggerInterceptor());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlinedButton(onPressed: _callAPI, child: Text('Call API')),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ListAPIScreen()),
                );
              },
              child: Text('Open List API Screen'),
            ),
            // OutlinedButton(
            //   onPressed: () async {
            //     List<File> logFiles = await C9.getListLogFiles();
            //     for (var file in logFiles) {
            //       print(
            //         "log file: ${file.path} - length: ${await file.length()}",
            //       );
            //     }
            //   },
            //   child: Text('Get Log Files'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> _callAPI() async {
    dio.get('/get');
    dio.post('/post');
    dio.patch('/patch');
    dio.put('/put');
    dio.delete('/delete');

    dio.get('/deny');
    dio.get('/encoding/utf8');
    dio.get('/gzip');
    dio.get('/html');
    dio.get('/json');
    dio.get('/xml');

    dio.get('/status/200');
    dio.get('/status/400');
    dio.get('/status/500');
  }
}
