import 'package:pixel_app_flutter/domain/app/app.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class LoggerStorage extends ValueStore<List<LogRecord>> {
  Future<void> write(LogRecord record);

  Future<void> writeAll(List<LogRecord> records);
}

extension ShortCutLoggerStorageExtension on LoggerStorage {
  Future<void> logInfo(String message, String loggerName) {
    return write(LogRecord(Level.info, message, loggerName));
  }

  Future<void> logError(String message, String loggerName) {
    return write(LogRecord(Level.error, message, loggerName));
  }

  Future<void> logSevere(String message, String loggerName) {
    return write(LogRecord(Level.severe, message, loggerName));
  }
}
