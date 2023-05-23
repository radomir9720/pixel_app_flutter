import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@immutable
class TwoUint16WithStatusBody extends IntBytesConvertibleWithStatus {
  TwoUint16WithStatusBody({
    required this.first,
    required this.second,
    required super.status,
  }) : super(value: _toUint32(first, second));

  TwoUint16WithStatusBody.fromFunctionId({
    required this.first,
    required this.second,
    required super.id,
  }) : super.fromId(value: _toUint32(first, second));

  TwoUint16WithStatusBody.normal({
    required this.first,
    required this.second,
  }) : super.normal(_toUint32(first, second));

  const TwoUint16WithStatusBody.zero()
      : first = 0,
        second = 0,
        super.normal(0);

  factory TwoUint16WithStatusBody.builder(int functionId, int value) {
    final bytes = value.toBytesUint32;
    return TwoUint16WithStatusBody.fromFunctionId(
      id: functionId,
      first: bytes.sublist(0, 2).toIntFromUint16,
      second: bytes.sublist(2, 4).toIntFromUint16,
    );
  }

  final int first;

  final int second;

  static int _toUint32(int first, int second) {
    return uint32ToInt([
      ...intToBytesUint16(first),
      ...intToBytesUint16(second),
    ]);
  }

  @override
  List<Object?> get props => [
        ...super.props,
        first,
        second,
        status,
      ];

  static Uint32WithStatusBytesConverter<TwoUint16WithStatusBody>
      get converter =>
          const Uint32WithStatusBytesConverter(TwoUint16WithStatusBody.builder);

  @override
  BytesConverter<TwoUint16WithStatusBody> get bytesConverter => converter;
}
