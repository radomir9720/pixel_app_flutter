import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/mixins.dart';

class HighVoltage extends IntBytesConvertibleWithStatus {
  const HighVoltage({required super.value, required super.status});

  const HighVoltage.zero() : super.normal(0);

  HighVoltage.fromFunctionId(int id, {required super.value})
      : super.fromId(id: id);

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
      dataParser: (bytes) => bytes.toIntFromUint16,
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
      ...model.value.toBytesUint16,
    ];
  }
}
