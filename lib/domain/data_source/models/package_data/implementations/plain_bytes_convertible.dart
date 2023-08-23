import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class PlainBytesConvertible extends Equatable implements BytesConvertible {
  const PlainBytesConvertible(this.bytes);

  final List<int> bytes;

  @override
  BytesConverter<PlainBytesConvertible> get bytesConverter =>
      const PlainBytesConvertibleConverter();

  @override
  List<Object?> get props => [bytes];

  @override
  List<int> get toBytes => bytesConverter.toBytes(this);
}

class PlainBytesConvertibleConverter
    extends BytesConverter<PlainBytesConvertible> {
  const PlainBytesConvertibleConverter();

  @override
  PlainBytesConvertible fromBytes(List<int> bytes) {
    return PlainBytesConvertible(bytes);
  }

  @override
  List<int> toBytes(PlainBytesConvertible model) {
    return model.bytes;
  }
}
