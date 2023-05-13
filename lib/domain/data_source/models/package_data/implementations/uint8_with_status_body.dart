import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@sealed
@immutable
class Uint8WithStatusBody extends IntBytesConvertibleWithStatus {
  const Uint8WithStatusBody({required super.value, required super.status});

  Uint8WithStatusBody.fromFunctionId({required super.id, required super.value})
      : super.fromId();

  factory Uint8WithStatusBody.builder(int functionId, int value) {
    return Uint8WithStatusBody.fromFunctionId(
      id: functionId,
      value: value,
    );
  }

  static Uint8WithStatusBytesConverter<Uint8WithStatusBody> get converter =>
      const Uint8WithStatusBytesConverter(Uint8WithStatusBody.builder);

  @override
  BytesConverter<Uint8WithStatusBody> get bytesConverter => converter;
}
