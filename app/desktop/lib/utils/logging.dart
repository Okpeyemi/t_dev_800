import 'dart:io';

import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

Future<String> getLogFilePath() async {
  var appDir = await getApplicationDocumentsDirectory();

  return "${appDir.path}/logs-${DateTime.now().toIso8601String().split('T')[0]}.log";
}

late Logger logger;

Future<void> initLogger() async {
  final printer = SimplePrinter(colors: false);
  try {
    final logPath = await getLogFilePath();
    logger = Logger(printer: printer, output: FileOutput(file: File(logPath)));
  } catch (e) {
    logger = Logger(printer: printer);
    logger.e('Failed to initialize file logging');
  }
}
