import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';

class EmptyBody extends BytesConvertible {
  const EmptyBody();

  @override
  BytesConverter<BytesConvertible> get bytesConverter =>
      const DefaultEmptyBodyConverter();

  @override
  List<Object?> get props => [];
}

class DefaultEmptyBodyConverter extends BytesConverter<EmptyBody> {
  const DefaultEmptyBodyConverter();

  @override
  EmptyBody fromBytes(List<int> bytes) => const EmptyBody();

  @override
  List<int> toBytes(EmptyBody model) => const [];
}

abstract class EmptyBodyConverter<T extends EmptyBody>
    extends BytesConverter<T> {
  const EmptyBodyConverter();

  @override
  List<int> toBytes(T model) => [];
}
