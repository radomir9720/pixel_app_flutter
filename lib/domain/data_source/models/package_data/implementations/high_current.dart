import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/mixins.dart';

// TODO(Radomir): package format has changed
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

class HighCurrentConverter extends BytesConverter<HighCurrent>
    with PeriodicValueStatusOrOkEventFunctionIdMxixn {
  const HighCurrentConverter();

  @override
  HighCurrent fromBytes(List<int> bytes) {
    return whenFunctionId(
      body: bytes,
      dataParser: (bytes) => bytes.toIntFromInt32.fromMilli,
      status: (data, status) => HighCurrent(status: status, value: data),
      okEvent: (data) {
        return HighCurrent(status: PeriodicValueStatus.normal, value: data);
      },
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
