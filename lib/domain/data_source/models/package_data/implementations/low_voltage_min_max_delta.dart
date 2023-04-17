import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@sealed
@immutable
class LowVoltageMinMaxDelta extends BytesConvertibleWithStatus {
  const LowVoltageMinMaxDelta({
    required this.min,
    required this.max,
    required this.delta,
    required super.status,
  });

  const LowVoltageMinMaxDelta.zero()
      : min = 0,
        max = 0,
        delta = 0,
        super.normal();

  LowVoltageMinMaxDelta.fromFunctionId(
    super.id, {
    required this.min,
    required this.max,
    required this.delta,
  }) : super.fromId();

  final double min;
  final double max;
  final double delta;

  @override
  List<Object?> get props => [...super.props, min, max, delta];

  @override
  BytesConverter<LowVoltageMinMaxDelta> get bytesConverter =>
      const LowVoltageMinMaxDeltaConverter();
}

class LowVoltageMinMaxDeltaConverter
    implements BytesConverter<LowVoltageMinMaxDelta> {
  const LowVoltageMinMaxDeltaConverter();

  @override
  LowVoltageMinMaxDelta fromBytes(List<int> bytes) {
    return LowVoltageMinMaxDelta.fromFunctionId(
      bytes[0],
      min: bytes.sublist(1, 3).toIntFromUint16.fromMilli,
      max: bytes.sublist(3, 5).toIntFromUint16.fromMilli,
      delta: bytes.sublist(5, 7).toIntFromUint16.fromMilli,
    );
  }

  @override
  List<int> toBytes(LowVoltageMinMaxDelta model) {
    return [
      ...model.status.toBytes,
      ...model.min.toMilli.toBytesUint16,
      ...model.max.toMilli.toBytesUint16,
      ...model.delta.toMilli.toBytesUint16,
    ];
  }
}
