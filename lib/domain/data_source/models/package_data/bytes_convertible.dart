import 'package:equatable/equatable.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

abstract class BytesConvertible extends Equatable {
  const BytesConvertible();

  BytesConverter get bytesConverter;

  List<int> get toBytes => bytesConverter.toBytes(this);
}

extension OnExtension on BytesConvertible {
  R? on<R, T extends BytesConvertible>(R Function(T model) method) {
    if (this is T) return method(this as T);
    return null;
  }

  void voidOn<T extends BytesConvertible>(void Function(T model) method) {
    if (this is T) return method(this as T);
  }
}
