import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/mixins.dart';

// TODO(Radomir): package format has changed
class HighVoltage extends BytesConvertibleWithStatus {
  const HighVoltage({required this.value, required super.status});

  const HighVoltage.zero()
      : value = 0,
        super.normal();

  HighVoltage.fromFunctionId(super.id, {required this.value}) : super.fromId();

  /// Volts
  final double value;

  @override
  List<Object?> get props => [...super.props, value];

  @override
  BytesConverter<HighVoltage> get bytesConverter =>
      const HighVoltageConverter();
}

class HighVoltageConverter extends BytesConverter<HighVoltage>
    with PeriodicValueStatusOrOkEventFunctionIdMxixn {
  const HighVoltageConverter();

  @override
  HighVoltage fromBytes(List<int> bytes) {
    return whenFunctionId(
      body: bytes,
      dataParser: (bytes) => bytes.toIntFromUint32.fromMilli,
      status: (data, status) {
        return HighVoltage(status: status, value: data);
      },
      okEvent: (data) {
        return HighVoltage(status: PeriodicValueStatus.normal, value: data);
      },
    );
  }

  @override
  List<int> toBytes(HighVoltage model) {
    return [
      ...model.status.toBytes,
      // converting from volts to millivolts
      ...model.value.toMilli.toBytesUint32,
    ];
  }
}
