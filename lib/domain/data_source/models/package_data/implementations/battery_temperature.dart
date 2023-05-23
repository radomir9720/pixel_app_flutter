import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/function_id.dart';

class BatteryTemperatureFirstBatch extends BytesConvertible {
  const BatteryTemperatureFirstBatch({
    required this.mos,
    required this.balancer,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
  });

  const BatteryTemperatureFirstBatch.zero()
      : mos = 0,
        balancer = 0,
        first = 0,
        second = 0,
        third = 0,
        fourth = 0,
        fifth = 0;

  final int mos;

  final int balancer;

  final int first;

  final int second;

  final int third;

  final int fourth;

  final int fifth;

  @override
  List<Object?> get props => [
        mos,
        balancer,
        first,
        second,
        third,
        fourth,
        fifth,
      ];

  @override
  BytesConverter<BatteryTemperatureFirstBatch> get bytesConverter =>
      BatteryTemperatureFirstBatchConverter();
}

class BatteryTemperatureSecondBatch extends BytesConvertible
    with EquatableMixin {
  const BatteryTemperatureSecondBatch({
    required this.sixth,
    required this.seventh,
    required this.eighth,
    required this.ninth,
    required this.tenth,
    required this.eleventh,
    required this.twelfth,
  });

  const BatteryTemperatureSecondBatch.zero()
      : sixth = 0,
        seventh = 0,
        eighth = 0,
        ninth = 0,
        tenth = 0,
        eleventh = 0,
        twelfth = 0;

  final int sixth;

  final int seventh;

  final int eighth;

  final int ninth;

  final int tenth;

  final int eleventh;

  final int twelfth;

  @override
  List<Object?> get props => [
        sixth,
        seventh,
        eighth,
        ninth,
        tenth,
        eleventh,
        twelfth,
      ];

  @override
  BytesConverter<BatteryTemperatureSecondBatch> get bytesConverter =>
      BatteryTemperatureSecondBatchConverter();
}

class BatteryTemperatureThirdBatch extends BytesConvertible
    with EquatableMixin {
  const BatteryTemperatureThirdBatch({
    required this.thirteenth,
    required this.fourteenth,
    required this.fifteenth,
    required this.sixteenth,
    required this.seventeenth,
    required this.eighteenth,
    required this.nineteenth,
  });

  const BatteryTemperatureThirdBatch.zero()
      : thirteenth = 0,
        fourteenth = 0,
        fifteenth = 0,
        sixteenth = 0,
        seventeenth = 0,
        eighteenth = 0,
        nineteenth = 0;

  final int thirteenth;

  final int fourteenth;

  final int fifteenth;

  final int sixteenth;

  final int seventeenth;

  final int eighteenth;

  final int nineteenth;

  @override
  List<Object?> get props => [
        thirteenth,
        fourteenth,
        fifteenth,
        sixteenth,
        seventeenth,
        eighteenth,
        nineteenth,
      ];

  @override
  BytesConverter<BatteryTemperatureThirdBatch> get bytesConverter =>
      BatteryTemperatureThirdBatchConverter();
}

abstract class BatteryTemperatureConverter<T extends BytesConvertible>
    extends BytesConverter<T> {
  const BatteryTemperatureConverter({
    required this.convertibleBuilder,
  });

  final T Function(
    int first,
    int second,
    int third,
    int fourth,
    int fifth,
    int sixth,
    int seventh,
  ) convertibleBuilder;

  @override
  T fromBytes(List<int> bytes) {
    return convertibleBuilder(
      bytes[1],
      bytes[2],
      bytes[3],
      bytes[4],
      bytes[5],
      bytes[6],
      bytes[7],
    );
  }
}

class BatteryTemperatureFirstBatchConverter
    extends BatteryTemperatureConverter<BatteryTemperatureFirstBatch> {
  BatteryTemperatureFirstBatchConverter()
      : super(
          convertibleBuilder: (
            first,
            second,
            third,
            fourth,
            fifth,
            sixth,
            seventh,
          ) {
            return BatteryTemperatureFirstBatch(
              mos: first,
              balancer: second,
              first: third,
              second: fourth,
              third: fifth,
              fourth: sixth,
              fifth: seventh,
            );
          },
        );

  @override
  List<int> toBytes(BatteryTemperatureFirstBatch model) {
    return [
      FunctionId.okEventId,
      ...model.mos.toBytesInt8,
      ...model.balancer.toBytesInt8,
      ...model.first.toBytesInt8,
      ...model.second.toBytesInt8,
      ...model.third.toBytesInt8,
      ...model.fourth.toBytesInt8,
      ...model.fifth.toBytesInt8,
    ];
  }
}

class BatteryTemperatureSecondBatchConverter
    extends BatteryTemperatureConverter<BatteryTemperatureSecondBatch> {
  BatteryTemperatureSecondBatchConverter()
      : super(
          convertibleBuilder: (
            first,
            second,
            third,
            fourth,
            fifth,
            sixth,
            seventh,
          ) {
            return BatteryTemperatureSecondBatch(
              sixth: first,
              seventh: second,
              eighth: third,
              ninth: fourth,
              tenth: fifth,
              eleventh: sixth,
              twelfth: seventh,
            );
          },
        );

  @override
  List<int> toBytes(BatteryTemperatureSecondBatch model) {
    return [
      FunctionId.okEventId,
      ...model.sixth.toBytesInt8,
      ...model.seventh.toBytesInt8,
      ...model.eighth.toBytesInt8,
      ...model.ninth.toBytesInt8,
      ...model.tenth.toBytesInt8,
      ...model.eleventh.toBytesInt8,
      ...model.twelfth.toBytesInt8,
    ];
  }
}

class BatteryTemperatureThirdBatchConverter
    extends BatteryTemperatureConverter<BatteryTemperatureThirdBatch> {
  BatteryTemperatureThirdBatchConverter()
      : super(
          convertibleBuilder: (
            first,
            second,
            third,
            fourth,
            fifth,
            sixth,
            seventh,
          ) {
            return BatteryTemperatureThirdBatch(
              thirteenth: first,
              fourteenth: second,
              fifteenth: third,
              sixteenth: fourth,
              seventeenth: fifth,
              eighteenth: sixth,
              nineteenth: seventh,
            );
          },
        );

  @override
  List<int> toBytes(BatteryTemperatureThirdBatch model) {
    return [
      FunctionId.okEventId,
      ...model.thirteenth.toBytesInt8,
      ...model.fourteenth.toBytesInt8,
      ...model.fifteenth.toBytesInt8,
      ...model.sixteenth.toBytesInt8,
      ...model.seventeenth.toBytesInt8,
      ...model.eighteenth.toBytesInt8,
      ...model.nineteenth.toBytesInt8,
    ];
  }
}
