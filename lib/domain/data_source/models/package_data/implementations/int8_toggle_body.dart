import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/function_id.dart';

class Int8ToggleBody extends BytesConvertible {
  const Int8ToggleBody({required this.value});

  final int value;

  @override
  BytesConverter<Int8ToggleBody> get bytesConverter =>
      const Int8ToggleBodyConverter();

  @override
  List<Object?> get props => [value];
}

class Int8ToggleBodyConverter extends BytesConverter<Int8ToggleBody> {
  const Int8ToggleBodyConverter();

  @override
  Int8ToggleBody fromBytes(List<int> bytes) {
    return Int8ToggleBody(value: bytes[1]);
  }

  @override
  List<int> toBytes(Int8ToggleBody model) {
    return [
      FunctionId.toggle.value,
      ...model.value.toBytesInt8,
    ];
  }
}
