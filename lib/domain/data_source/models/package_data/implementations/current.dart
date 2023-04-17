import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/double.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@sealed
@immutable
class Current extends BytesConvertibleWithStatus {
  const Current({required this.value, required super.status});

  const Current.zero()
      : value = 0,
        super.normal();

  Current.fromFunctionId(super.id, {required this.value}) : super.fromId();

  final double value;

  @override
  List<Object?> get props => [...super.props, value];

  @override
  BytesConverter<Current> get bytesConverter => const CurrentBytesConverter();
}

class CurrentBytesConverter extends BytesConverter<Current> {
  const CurrentBytesConverter();

  @override
  Current fromBytes(List<int> bytes) {
    return Current.fromFunctionId(
      bytes[0],
      value: bytes.sublist(1).toIntFromUint32.fromMilli,
    );
  }

  @override
  List<int> toBytes(Current model) {
    return [
      ...model.status.toBytes,
      ...model.value.toMilli.toBytesUint32,
    ];
  }
}
