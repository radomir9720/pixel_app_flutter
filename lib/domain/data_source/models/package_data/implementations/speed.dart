import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

class Speed extends BytesConvertibleWithStatus {
  const Speed({required this.speed, required super.status});

  Speed.fromFunctionId(
    super.id, {
    required this.speed,
  }) : super.fromId();

  final int speed;

  @override
  List<Object?> get props => [...super.props, speed];

  @override
  BytesConverter<Speed> get bytesConverter => const SpeedConverter();
}

class SpeedConverter extends BytesConverter<Speed> {
  const SpeedConverter();

  @override
  Speed fromBytes(List<int> bytes) {
    return Speed.fromFunctionId(
      bytes[0],
      speed: bytes.sublist(1).toIntFromUint8,
    );
  }

  @override
  List<int> toBytes(Speed model) {
    return [
      ...model.status.toBytes,
      ...model.speed.toBytesUint8,
    ];
  }
}
