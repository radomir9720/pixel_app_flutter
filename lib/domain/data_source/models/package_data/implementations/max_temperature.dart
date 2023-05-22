import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/mixins.dart';

class MaxTemperature extends BytesConvertibleWithStatus {
  const MaxTemperature({required this.value, required super.status});

  const MaxTemperature.zero()
      : value = 0,
        super.normal();

  MaxTemperature.fromFunctionId(super.id, {required this.value})
      : super.fromId();

  final int value;

  @override
  List<Object?> get props => [...super.props, value];

  @override
  BytesConverter<MaxTemperature> get bytesConverter =>
      const MaxTemperatureConverter();
}

class MaxTemperatureConverter extends BytesConverter<MaxTemperature>
    with PeriodicValueStatusOrOkEventFunctionIdMxixn {
  const MaxTemperatureConverter();

  @override
  MaxTemperature fromBytes(List<int> bytes) {
    return whenFunctionId(
      body: bytes,
      dataParser: (b) => b.toIntFromInt8,
      status: (data, status) {
        return MaxTemperature(
          status: status,
          value: data,
        );
      },
      okEvent: (data) {
        return MaxTemperature(
          status: PeriodicValueStatus.normal,
          value: data,
        );
      },
    );
  }

  @override
  List<int> toBytes(MaxTemperature model) {
    return [
      ...model.status.toBytes,
      ...model.value.toBytesInt8,
    ];
  }
}
