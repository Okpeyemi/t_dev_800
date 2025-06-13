import 'package:ahouefa/app.dart';
import 'package:ahouefa/config/settings.dart';
import 'package:ahouefa/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:ahouefa/utils/logging.dart';

void main(List<String> args) async {
  Settings.init();
  await initLogger();
  await Directories.init();
  runApp(
    MaterialApp(
      home: App(),
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
    ),
  );
}
