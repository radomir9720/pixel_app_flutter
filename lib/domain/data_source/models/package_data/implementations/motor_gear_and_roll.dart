import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

enum MotorGear {
  reverse(0x02),
  neutral(0x00),
  drive(0x01),
  low(0x03),
  boost(0x04),
  unknown(0x0F);

  const MotorGear(this.id);
  final int id;

  static MotorGear fromId(int id) {
    return MotorGear.values.firstWhere(
      (element) => element.id == id,
      orElse: () => MotorGear.unknown,
    );
  }
}

enum MotorRollDirection {
  stop(0x00),
  forward(0x01),
  reverse(0x02),
  unknown(0x0F);

  const MotorRollDirection(this.id);
  final int id;

  static MotorRollDirection fromId(int id) {
    return MotorRollDirection.values.firstWhere(
      (element) => element.id == id,
      orElse: () => MotorRollDirection.unknown,
    );
  }
}

class MotorGearAndRoll extends IntBytesConvertibleWithStatus {
  MotorGearAndRoll({
    required this.firstMotorGear,
    required this.firstMotorRollDirection,
    required this.secondMotorGear,
    required this.secondMotorRollDirection,
    required super.status,
  }) : super(
          value: _toUint32(
            firstMotorGear: firstMotorGear,
            firstMotorRollDirection: firstMotorRollDirection,
            secondMotorGear: secondMotorGear,
            secondMotorRollDirection: secondMotorRollDirection,
          ),
        );

  factory MotorGearAndRoll.unknown() => MotorGearAndRoll(
        firstMotorGear: MotorGear.unknown,
        firstMotorRollDirection: MotorRollDirection.unknown,
        secondMotorGear: MotorGear.unknown,
        secondMotorRollDirection: MotorRollDirection.unknown,
        status: PeriodicValueStatus.normal,
      );

  MotorGearAndRoll.fromId({
    required this.firstMotorGear,
    required this.firstMotorRollDirection,
    required this.secondMotorGear,
    required this.secondMotorRollDirection,
    required super.id,
  }) : super.fromId(
          value: _toUint32(
            firstMotorGear: firstMotorGear,
            firstMotorRollDirection: firstMotorRollDirection,
            secondMotorGear: secondMotorGear,
            secondMotorRollDirection: secondMotorRollDirection,
          ),
        );

  factory MotorGearAndRoll.builder(int functionId, int value) {
    final bytes = value.toBytesUint32;

    return MotorGearAndRoll.fromId(
      id: functionId,
      firstMotorGear: MotorGear.fromId(bytes[0]),
      firstMotorRollDirection: MotorRollDirection.fromId(bytes[1]),
      secondMotorGear: MotorGear.fromId(bytes[2]),
      secondMotorRollDirection: MotorRollDirection.fromId(bytes[3]),
    );
  }

  final MotorGear firstMotorGear;
  final MotorRollDirection firstMotorRollDirection;
  final MotorGear secondMotorGear;
  final MotorRollDirection secondMotorRollDirection;

  MotorGear get gear =>
      firstMotorGear == secondMotorGear ? firstMotorGear : MotorGear.unknown;

  MotorRollDirection get rollDirection =>
      firstMotorRollDirection == secondMotorRollDirection
          ? firstMotorRollDirection
          : MotorRollDirection.unknown;

  static int _toUint32({
    required MotorGear firstMotorGear,
    required MotorRollDirection firstMotorRollDirection,
    required MotorGear secondMotorGear,
    required MotorRollDirection secondMotorRollDirection,
  }) {
    return [
      firstMotorGear.id,
      firstMotorRollDirection.id,
      secondMotorGear.id,
      secondMotorRollDirection.id,
    ].toIntFromUint32;
  }

  static Uint32WithStatusBytesConverter<MotorGearAndRoll> get converter =>
      const Uint32WithStatusBytesConverter(MotorGearAndRoll.builder);

  @override
  BytesConverter<MotorGearAndRoll> get bytesConverter => converter;
}
