import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';

abstract class BytesConverter<T extends BytesConvertible> {
  const BytesConverter();

  List<int> toBytes(T model);

  T fromBytes(List<int> bytes);
}
