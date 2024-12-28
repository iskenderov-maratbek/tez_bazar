import 'package:ansicolor/ansicolor.dart';

// Создаем и настраиваем логгер
import 'dart:io';

// Методы для логирования
logSys(String message) {
  final infoPen = AnsiPen()..xterm(246);
  print(infoPen('[---SYSTEM] $message'));
}

logWarning(message) {
  final warningPen = AnsiPen()..xterm(160);
  print(warningPen('[--WARNING] $message'));
}

logError(message) {
  final errorPen = AnsiPen()..xterm(197);
  print(errorPen('[----ERROR] $message'));
}

logView(message) {
  final severePen = AnsiPen()..xterm(045);
  print(severePen('[-----VIEW] $message'));
}

logServer(message) {
  final severePen = AnsiPen()..xterm(227);
  print(severePen('[---SERVER] $message'));
}

logInfo(message) {
  final severePen = AnsiPen()..xterm(046);
  print(severePen('[-----INFO] $message'));
}
