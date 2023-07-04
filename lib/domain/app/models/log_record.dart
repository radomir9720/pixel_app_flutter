import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:re_seedwork/re_seedwork.dart';

enum Level {
  info('INFO'),
  error('ERROR'),
  severe('SEVERE');

  const Level(this.id);

  final String id;

  static Level fromString(String id) {
    return Level.values.firstWhere((element) => element.id == id);
  }

  bool get isSevere => this == Level.severe;
  bool get isError => this == Level.error;
  bool get isInfo => this == Level.info;
}

@immutable
class LogRecord {
  LogRecord(
    this.level,
    this.message,
    this.loggerName, [
    DateTime? dateTime,
  ]) : dateTime = dateTime ?? DateTime.now();

  factory LogRecord.fromMap(Map<String, dynamic> map) {
    return LogRecord(
      map.parseAndMap('level', Level.fromString),
      map.parse('message'),
      map.parse('loggerName'),
      map.parseAndMap('dateTime', DateTime.fromMillisecondsSinceEpoch),
    );
  }
  factory LogRecord.fromJson(String source) =>
      LogRecord.fromMap(jsonDecode(source) as Map<String, dynamic>);

  final Level level;
  final String message;
  final String loggerName;
  final DateTime dateTime;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LogRecord &&
        other.level == level &&
        other.message == message &&
        other.loggerName == loggerName &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return level.hashCode ^
        message.hashCode ^
        loggerName.hashCode ^
        dateTime.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'level': level.id,
      'message': message,
      'loggerName': loggerName,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => '${DateFormat('MM.dd HH:mm:ss').format(dateTime)} '
      '[${level.id}] '
      '$loggerName: $message';

  LogRecord copyWith({
    Level? level,
    String? message,
    String? loggerName,
    DateTime? dateTime,
  }) {
    return LogRecord(
      level ?? this.level,
      message ?? this.message,
      loggerName ?? this.loggerName,
      dateTime ?? this.dateTime,
    );
  }
}
