import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@sealed
@immutable
class Voltage extends BytesConvertibleWithStatus {
  const Voltage({required this.value, required super.status});

  const Voltage.zero()
      : value = 0,
        super.normal();

  Voltage.fromFunctionId(super.id, {required this.value}) : super.fromId();

  final double value;

  @override
  List<Object?> get props => [...super.props, value];

  @override
  BytesConverter<Voltage> get bytesConverter => const VoltageBytesConverter();
}

class VoltageBytesConverter extends BytesConverter<Voltage> {
  const VoltageBytesConverter();

  @override
  Voltage fromBytes(List<int> bytes) {
    return Voltage.fromFunctionId(
      bytes[0],
      // converting from millivolts to volts
      value: bytes.sublist(1).toIntFromUint32.fromMilli,
    );
  }

  @override
  List<int> toBytes(Voltage model) {
    return [
      ...model.status.toBytes,
      // converting from volts to millivolts
      ...model.value.toMilli.toBytesUint32,
    ];
  }
}
