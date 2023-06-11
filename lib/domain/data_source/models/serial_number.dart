import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:re_seedwork/re_seedwork.dart';

final class SerialNumber extends UnmodifiableListView<int> {
  SerialNumber(super.source);

  factory SerialNumber.fromString(String string) {
    return SerialNumber((jsonDecode(string) as List).cast<int>());
  }

  @override
  int get length => 8;

  @override
  String toString() => jsonEncode(this);
}

@immutable
final class SerialNumberChain {
  const SerialNumberChain({
    required this.id,
    required this.sn,
    required this.saveDateTime,
  });

  SerialNumberChain.now({
    required this.id,
    required this.sn,
  }) : saveDateTime = DateTime.now();

  factory SerialNumberChain.fromMap(Map<String, dynamic> map) {
    return SerialNumberChain(
      id: map.parse('id'),
      sn: map.parseAndMap<SerialNumber, String>('sn', SerialNumber.fromString),
      saveDateTime:
          map.parseAndMap('saveDateTime', DateTime.fromMillisecondsSinceEpoch),
    );
  }

  factory SerialNumberChain.fromJson(String source) =>
      SerialNumberChain.fromMap(jsonDecode(source) as Map<String, dynamic>);

  final String id;
  final SerialNumber sn;
  final DateTime saveDateTime;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sn': sn.toString(),
      'saveDateTime': saveDateTime.millisecondsSinceEpoch,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'SerialNumberChain(id: $id, sn: $sn, saveDateTime: $saveDateTime)';
}
