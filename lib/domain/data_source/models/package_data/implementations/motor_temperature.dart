import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

class MotorTemperature extends IntBytesConvertibleWithStatus {
  MotorTemperature({
    required this.firstMotor,
    required this.firstController,
    required this.secondMotor,
    required this.secondController,
    required super.status,
  }) : super(
          value: _toInt32(
            firstMotor,
            firstController,
            secondMotor,
            secondController,
          ),
        );

  MotorTemperature.fromId({
    required super.id,
    required this.firstMotor,
    required this.firstController,
    required this.secondMotor,
    required this.secondController,
  }) : super.fromId(
          value: _toInt32(
            firstMotor,
            firstController,
            secondMotor,
            secondController,
          ),
        );

  const MotorTemperature.zero()
      : firstMotor = 0,
        firstController = 0,
        secondMotor = 0,
        secondController = 0,
        super.normal(0);

  factory MotorTemperature.builder(int functionId, int value) {
    final bytes = value.toBytesInt32;
    return MotorTemperature.fromId(
      id: functionId,
      firstMotor: [bytes[0]].toIntFromInt8,
      firstController: [bytes[1]].toIntFromInt8,
      secondMotor: [bytes[2]].toIntFromInt8,
      secondController: [bytes[3]].toIntFromInt8,
    );
  }

  final int firstMotor;
  final int firstController;

  final int secondMotor;
  final int secondController;

  static int _toInt32(
    int first,
    int second,
    int third,
    int fourth,
  ) {
    return int32ToInt([
      ...intToBytesInt8(first),
      ...intToBytesInt8(second),
      ...intToBytesInt8(third),
      ...intToBytesInt8(fourth),
    ]);
  }

  @override
  List<Object?> get props => [
        ...super.props,
        firstMotor,
        firstController,
        secondMotor,
        secondController,
        status,
      ];

  static Int32WithStatusBytesConverter<MotorTemperature> get converter =>
      const Int32WithStatusBytesConverter(MotorTemperature.builder);

  @override
  BytesConverter<MotorTemperature> get bytesConverter => converter;
}
