import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@immutable
class Int16WithStatusBody extends IntBytesConvertibleWithStatus {
  const Int16WithStatusBody({
    required super.status,
    required super.value,
  });

  Int16WithStatusBody.fromFunctionId({
    required super.value,
    required super.id,
  }) : super.fromId();

  const Int16WithStatusBody.normal(
    super.value,
  ) : super.normal();

  const Int16WithStatusBody.zero() : super.normal(0);

  factory Int16WithStatusBody.builder(int functionId, int value) {
    return Int16WithStatusBody.fromFunctionId(
      id: functionId,
      value: value,
    );
  }

  static Int16WithStatusBytesConverter<Int16WithStatusBody> get converter =>
      const Int16WithStatusBytesConverter(Int16WithStatusBody.builder);

  @override
  BytesConverter<Int16WithStatusBody> get bytesConverter => converter;
}
