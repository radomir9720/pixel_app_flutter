import 'dart:math';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/app/app.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class LoggerStorageImpl extends InMemoryValueStore<List<LogRecord>>
    with Lock<bool>
    implements LoggerStorage {
  LoggerStorageImpl({
    required this.prefs,
    this.maxRecords = 1000,
    this.maxMessageLength = 500,
    Debouncer? debouncer,
  })  : debouncer = debouncer ?? Debouncer(milliseconds: 700),
        super(_getRecordsFromDB(prefs));

  @protected
  final SharedPreferences prefs;

  @protected
  final int maxRecords;

  @protected
  final int maxMessageLength;

  @visibleForTesting
  final Debouncer debouncer;

  @visibleForTesting
  static const key = 'Logs';

  static List<LogRecord> _getRecordsFromDB(SharedPreferences prefs) {
    try {
      return prefs.getStringList(key)?.map(LogRecord.fromJson).toList() ?? [];
    } catch (e, s) {
      Future<void>.error(e, s);
      return [];
    }
  }

  @override
  Future<void> write(LogRecord record) async {
    await _append([_substringIfNeedTo(record)]);
  }

  @override
  Future<void> close() {
    debouncer.dispose();
    return super.close();
  }

  @override
  Future<void> writeAll(List<LogRecord> records) async {
    await _append([for (final record in records) _substringIfNeedTo(record)]);
  }

  Future<void> _append(List<LogRecord> records) async {
    await acquire(() {
      var _records = [...data, ...records];
      if (_records.length > maxRecords) {
        _records = _records.sublist(
          _records.length - maxRecords,
          _records.length,
        );
      }
      return put(_records);
    });
    debouncer.run(() {
      prefs.setStringList(key, data.map((e) => e.toJson()).toList());
    });
  }

  LogRecord _substringIfNeedTo(LogRecord record) {
    if (!record.level.isInfo) return record;

    return record.copyWith(
      message: record.message.substring(
            0,
            min(maxMessageLength, record.message.length),
          ) +
          (record.message.length > maxMessageLength ? '...' : ''),
    );
  }
}
