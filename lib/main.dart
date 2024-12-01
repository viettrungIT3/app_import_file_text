import 'package:flutter/material.dart';
import 'package:import_file_text/configs/app_config.dart';

import 'screen/text_file_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TextFileScreen(),
    );
  }
}
