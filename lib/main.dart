import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_downloader/screens/donwnloads_screen.dart';
import 'package:youtube_downloader/screens/home_page.dart';

import 'providers/downloads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initializeService();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Downloads>(create: (ctx) => Downloads())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        DownloadsScreen.routeName: (context) => DownloadsScreen(),
      },
    );
  }
}
