import 'dart:collection';

import 'package:logging/logging.dart';

class LoggerRecordsBuffer {
  LoggerRecordsBuffer({this.size = 500}) : _records = ListQueue(size);

  final ListQueue<LogRecord> _records;

  final int size;

  List<LogRecord> get records => _records.toList();

  void add(LogRecord record) {
    _records.add(record);
    if (_records.length > size) {
      _records.removeFirst();
    }
  }
}
