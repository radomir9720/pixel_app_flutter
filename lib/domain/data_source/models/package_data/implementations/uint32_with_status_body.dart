import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@sealed
@immutable
class Uint32WithStatusBody extends IntBytesConvertibleWithStatus {
  const Uint32WithStatusBody({required super.value, required super.status});

  const Uint32WithStatusBody.zero() : super.normal(0);

  Uint32WithStatusBody.fromFunctionId({required super.id, required super.value})
      : super.fromId();

  factory Uint32WithStatusBody.builder(int functionId, int value) {
    return Uint32WithStatusBody.fromFunctionId(
      id: functionId,
      value: value,
    );
  }

  static Uint32WithStatusBytesConverter<Uint32WithStatusBody> get converter =>
      const Uint32WithStatusBytesConverter(Uint32WithStatusBody.builder);

  @override
  BytesConverter<Uint32WithStatusBody> get bytesConverter => converter;
}
