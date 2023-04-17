import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

class BatteryTemperatureFirstBatch extends BytesConvertibleWithStatus {
  const BatteryTemperatureFirstBatch({
    required this.mos,
    required this.balancer,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
    required super.status,
  });

  const BatteryTemperatureFirstBatch.zero()
      : mos = 0,
        balancer = 0,
        first = 0,
        second = 0,
        third = 0,
        fourth = 0,
        fifth = 0,
        super.normal();

  BatteryTemperatureFirstBatch.fromId(
    super.id, {
    required this.mos,
    required this.balancer,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
  }) : super.fromId();

  final int mos;

  final int balancer;

  final int first;

  final int second;

  final int third;

  final int fourth;

  final int fifth;

  @override
  List<Object?> get props => [
        status,
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

class BatteryTemperatureSecondBatch extends BytesConvertibleWithStatus
    with EquatableMixin
    implements BytesConvertible {
  const BatteryTemperatureSecondBatch({
    required this.sixth,
    required this.seventh,
    required this.eighth,
    required this.ninth,
    required this.tenth,
    required this.eleventh,
    required this.twelfth,
    required super.status,
  });

  const BatteryTemperatureSecondBatch.zero()
      : sixth = 0,
        seventh = 0,
        eighth = 0,
        ninth = 0,
        tenth = 0,
        eleventh = 0,
        twelfth = 0,
        super.normal();

  BatteryTemperatureSecondBatch.fromId(
    super.id, {
    required this.sixth,
    required this.seventh,
    required this.eighth,
    required this.ninth,
    required this.tenth,
    required this.eleventh,
    required this.twelfth,
  }) : super.fromId();

  final int sixth;

  final int seventh;

  final int eighth;

  final int ninth;

  final int tenth;

  final int eleventh;

  final int twelfth;

  @override
  List<Object?> get props => [
        status,
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

class BatteryTemperatureThirdBatch extends BytesConvertibleWithStatus
    with EquatableMixin
    implements BytesConvertible {
  const BatteryTemperatureThirdBatch({
    required this.thirteenth,
    required this.fourteenth,
    required this.fifteenth,
    required this.sixteenth,
    required this.seventeenth,
    required this.eighteenth,
    required this.nineteenth,
    required super.status,
  });

  const BatteryTemperatureThirdBatch.zero()
      : thirteenth = 0,
        fourteenth = 0,
        fifteenth = 0,
        sixteenth = 0,
        seventeenth = 0,
        eighteenth = 0,
        nineteenth = 0,
        super.normal();

  BatteryTemperatureThirdBatch.fromId(
    super.id, {
    required this.thirteenth,
    required this.fourteenth,
    required this.fifteenth,
    required this.sixteenth,
    required this.seventeenth,
    required this.eighteenth,
    required this.nineteenth,
  }) : super.fromId();

  final int thirteenth;

  final int fourteenth;

  final int fifteenth;

  final int sixteenth;

  final int seventeenth;

  final int eighteenth;

  final int nineteenth;

  @override
  List<Object?> get props => [
        status,
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
    // required this.satisfiesParameter,
  });

  final T Function(
    int functionId,
    int first,
    int second,
    int third,
    int fourth,
    int fifth,
    int sixth,
    int seventh,
  ) convertibleBuilder;

  // final bool Function(DataSourceParameterId parameterId) satisfiesParameter;

  @override
  T fromBytes(List<int> bytes) {
    return convertibleBuilder(
      bytes[0],
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
            id,
            first,
            second,
            third,
            fourth,
            fifth,
            sixth,
            seventh,
          ) {
            return BatteryTemperatureFirstBatch.fromId(
              id,
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
      ...model.status.toBytes,
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
            id,
            first,
            second,
            third,
            fourth,
            fifth,
            sixth,
            seventh,
          ) {
            return BatteryTemperatureSecondBatch.fromId(
              id,
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
      ...model.status.toBytes,
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
            id,
            first,
            second,
            third,
            fourth,
            fifth,
            sixth,
            seventh,
          ) {
            return BatteryTemperatureThirdBatch.fromId(
              id,
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
      ...model.status.toBytes,
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
