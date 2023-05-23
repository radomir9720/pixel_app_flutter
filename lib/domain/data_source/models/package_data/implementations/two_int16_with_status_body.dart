import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_converter.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/bytes_convertible_with_status.dart';

@immutable
class TwoInt16WithStatusBody extends IntBytesConvertibleWithStatus {
  TwoInt16WithStatusBody({
    required this.first,
    required this.second,
    required super.status,
  }) : super(value: _toInt32(first, second));

  TwoInt16WithStatusBody.fromFunctionId({
    required this.first,
    required this.second,
    required super.id,
  }) : super.fromId(value: _toInt32(first, second));

  TwoInt16WithStatusBody.normal({
    required this.first,
    required this.second,
  }) : super.normal(_toInt32(first, second));

  const TwoInt16WithStatusBody.zero()
      : first = 0,
        second = 0,
        super.normal(0);

  factory TwoInt16WithStatusBody.builder(int functionId, int value) {
    final bytes = value.toBytesInt32;
    return TwoInt16WithStatusBody.fromFunctionId(
      id: functionId,
      first: bytes.sublist(0, 2).toIntFromInt16,
      second: bytes.sublist(2, 4).toIntFromInt16,
    );
  }

  final int first;

  final int second;

  static int _toInt32(int first, int second) {
    return int32ToInt([
      ...intToBytesInt16(first),
      ...intToBytesInt16(second),
    ]);
  }

  @override
  List<Object?> get props => [
        ...super.props,
        first,
        second,
        status,
      ];

  static Int32WithStatusBytesConverter<TwoInt16WithStatusBody> get converter =>
      const Int32WithStatusBytesConverter(TwoInt16WithStatusBody.builder);

  @override
  BytesConverter<TwoInt16WithStatusBody> get bytesConverter => converter;
}
