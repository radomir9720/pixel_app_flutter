import 'dart:typed_data' as td show Endian;
import 'package:re_seedwork/re_seedwork.dart';

sealed class DataBytesRange {
  const DataBytesRange(this.key);

  final String key;

  bool get endianMatters;

  static DataBytesRange fromString(String string) {
    if (string == AllDataBytesRange.kKey) return const AllDataBytesRange();
    final split = string.split('_');
    if (split[0] == ManualDataBytesRange.kKey) {
      final range = split[1].split('-');
      return ManualDataBytesRange(
        start: int.parse(range[0]),
        end: int.parse(range[1]),
      );
    }

    throw Exception('Unknown data bytes range string format: "$string"');
  }

  String get stringify;

  R when<R>({
    required R Function(AllDataBytesRange range) all,
    required R Function(ManualDataBytesRange range) manual,
  }) {
    return switch (this) {
      (final AllDataBytesRange r) => all(r),
      (final ManualDataBytesRange r) => manual(r),
    };
  }

  List<int> getRange(List<int> data);
}

final class AllDataBytesRange extends DataBytesRange {
  const AllDataBytesRange() : super(kKey);

  static const kKey = 'all';

  @override
  List<int> getRange(List<int> data) => data;

  @override
  bool get endianMatters => true;

  @override
  String get stringify => kKey;
}

final class ManualDataBytesRange extends DataBytesRange {
  const ManualDataBytesRange({
    required this.start,
    required this.end,
  })  : assert(end > start, '"end" index should be bigger than "start" index'),
        super(kKey);

  const ManualDataBytesRange.first()
      : start = 0,
        end = 1,
        super(kKey);

  static const kKey = 'manual';

  final int start;
  final int end;

  ManualDataBytesRange get incrementStart {
    if (start + 1 >= end) return this;
    return ManualDataBytesRange(start: start + 1, end: end);
  }

  ManualDataBytesRange get incrementEnd {
    return ManualDataBytesRange(start: start, end: end + 1);
  }

  ManualDataBytesRange get decrementStart {
    if (start - 1 < 0) return this;
    return ManualDataBytesRange(start: start - 1, end: end);
  }

  ManualDataBytesRange get decrementEnd {
    if (end - 1 <= start) return this;
    return ManualDataBytesRange(start: start, end: end - 1);
  }

  @override
  List<int> getRange(List<int> data) => data.sublist(start, end);

  @override
  bool get endianMatters => end - start > 1;

  @override
  String get stringify => '${kKey}_$start-$end';
}

enum Endian {
  big,
  little;

  static Endian fromString(String id) {
    return Endian.values.firstWhere((element) => element.name == id);
  }

  R when<R>({
    required R Function() big,
    required R Function() little,
  }) {
    return switch (this) {
      Endian.big => big(),
      Endian.little => little(),
    };
  }

  td.Endian get toTypedData {
    return when(
      big: () => td.Endian.big,
      little: () => td.Endian.little,
    );
  }
}

enum Sign {
  signed,
  unsigned;

  static Sign fromString(String id) {
    return Sign.values.firstWhere((element) => element.name == id);
  }

  R when<R>({
    required R Function() signed,
    required R Function() unsigned,
  }) {
    return switch (this) {
      Sign.signed => signed(),
      Sign.unsigned => unsigned(),
    };
  }
}

class PackageDataParameters {
  const PackageDataParameters({
    required this.endian,
    required this.range,
    required this.sign,
  });

  const PackageDataParameters.initial()
      : endian = Endian.little,
        range = const AllDataBytesRange(),
        sign = Sign.unsigned;

  factory PackageDataParameters.fromMap(Map<String, dynamic> map) {
    return PackageDataParameters(
      endian: map.parseAndMap('endian', Endian.fromString),
      range: map.parseAndMap('range', DataBytesRange.fromString),
      sign: map.parseAndMap('sign', Sign.fromString),
    );
  }

  final Endian endian;

  final DataBytesRange range;

  final Sign sign;

  Map<String, dynamic> toMap() {
    return {
      'endian': endian.name,
      'range': range.stringify,
      'sign': sign.name,
    };
  }

  PackageDataParameters copyWith({
    Sign? sign,
    Endian? endian,
    DataBytesRange? range,
  }) {
    return PackageDataParameters(
      sign: sign ?? this.sign,
      range: range ?? this.range,
      endian: endian ?? this.endian,
    );
  }
}
