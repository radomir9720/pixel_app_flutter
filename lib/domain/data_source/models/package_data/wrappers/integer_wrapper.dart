import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';

@immutable
abstract class IntegerWrapper extends BytesConvertible {
  const IntegerWrapper(this.value);

  final int value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IntegerWrapper && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

abstract class IntegerWrapperConverter<T extends IntegerWrapper>
    extends BytesConverter<T> {
  const IntegerWrapperConverter({this.fixedBytesLength});

  final int? fixedBytesLength;

  @override
  List<int> toBytes(T model) {
    return DataSourcePackage.intToBytes(
      model.value,
      fixedBytesLength: fixedBytesLength,
    );
  }
}
