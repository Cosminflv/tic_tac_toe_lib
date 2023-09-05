import 'dart:io';
import 'package:logger/logger.dart';

Logger logger(Type type) {
  //final logFilePath = r'D:\tictactoe\tic_tac_toe_lib\lib\src\logs\$type.log';
  final logFilePath = r'dependency\tic_tac_toe_lib\lib\src\logs\$type.log';
  final logFilePathWithType = logFilePath.replaceFirst(r'$type', type.toString());
  final logFile = File(logFilePathWithType);
  //Logger(printer: CustomerPrinter(type.toString()), level: Level.trace);
  final printer = CustomerPrinter(type.toString(), logFile);
  return Logger(printer: printer);
}

class CustomerPrinter extends LogPrinter {
  final String className;
  final File logFile;
  CustomerPrinter(this.className, this.logFile);

  @override
  List<String> log(LogEvent event) {
    final color = PrettyPrinter.defaultLevelColors[event.level];
    final emoji = PrettyPrinter.defaultLevelEmojis[event.level];
    final time = PrettyPrinter(printTime: true).getTime(event.time);
    final message = event.message;

    final logMessage = '$time $emoji $className: $message';

    logFile.writeAsStringSync('$logMessage\n', mode: FileMode.append);

    return [color!('$time $emoji $className: $message')];
  }
}
