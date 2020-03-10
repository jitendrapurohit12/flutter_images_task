import 'package:flutter/material.dart';
import 'package:flutter_images_task/notifiers/images_notofier.dart';
import 'package:flutter_images_task/ui/screens/dashboard.dart';
import 'package:provider/provider.dart';

void main() => runApp(FlutterImagesTask());

class FlutterImagesTask extends StatefulWidget {
  @override
  _FlutterImagesTaskState createState() => _FlutterImagesTaskState();
}

class _FlutterImagesTaskState extends State<FlutterImagesTask> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImagesNotifier>(create: (_) => ImagesNotifier()),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        home: ScreenDashboard(),
      ),
    );
  }
}
