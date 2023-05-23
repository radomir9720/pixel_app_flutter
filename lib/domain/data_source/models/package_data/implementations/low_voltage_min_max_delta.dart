import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/mixins.dart';

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
        super(status: PeriodicValueStatus.normal);

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
    extends BytesConverter<LowVoltageMinMaxDelta>
    with PeriodicValueStatusOrOkEventFunctionIdMxixn {
  const LowVoltageMinMaxDeltaConverter();

  @override
  LowVoltageMinMaxDelta fromBytes(List<int> bytes) {
    return whenFunctionId(
      body: bytes,
      dataParser: (bytes) => (
        bytes.sublist(0, 2).toIntFromUint16.fromMilli,
        bytes.sublist(2, 4).toIntFromUint16.fromMilli,
        bytes.sublist(4, 6).toIntFromUint16.fromMilli
      ),
      status: (data, status) {
        return LowVoltageMinMaxDelta(
          status: status,
          min: data.$1,
          max: data.$2,
          delta: data.$3,
        );
      },
      okEvent: (data) {
        return LowVoltageMinMaxDelta(
          status: PeriodicValueStatus.normal,
          min: data.$1,
          max: data.$2,
          delta: data.$3,
        );
      },
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
