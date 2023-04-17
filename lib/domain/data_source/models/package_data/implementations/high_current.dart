import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

class HighCurrent extends BytesConvertibleWithStatus {
  const HighCurrent({required this.value, required super.status});

  const HighCurrent.zero()
      : value = 0,
        super.normal();

  HighCurrent.fromFunctionId(super.id, {required this.value}) : super.fromId();

  /// Ampers
  final double value;

  @override
  List<Object?> get props => [...super.props, value];

  @override
  BytesConverter<HighCurrent> get bytesConverter =>
      const HighCurrentConverter();
}

class HighCurrentConverter extends BytesConverter<HighCurrent> {
  const HighCurrentConverter();

  @override
  HighCurrent fromBytes(List<int> bytes) {
    return HighCurrent.fromFunctionId(
      bytes[0],
      // converting from milliampers to ampers
      value: bytes.sublist(1).toIntFromInt32.fromMilli,
    );
  }

  @override
  List<int> toBytes(HighCurrent model) {
    return [
      ...model.status.toBytes,
      // converting from ampers to milliampers
      ...model.value.toMilli.toBytesInt32,
    ];
  }
}
