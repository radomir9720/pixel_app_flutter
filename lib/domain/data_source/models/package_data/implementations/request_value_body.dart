import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/data_source_package_data_exceptions.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/function_id.dart';

class RequestValueBody extends BytesConvertible {
  const RequestValueBody();

  @override
  BytesConverter<BytesConvertible> get bytesConverter =>
      const RequestValueConverter();

  @override
  List<Object?> get props => [];
}

class RequestValueConverter extends BytesConverter<RequestValueBody> {
  const RequestValueConverter();
  @override
  RequestValueBody fromBytes(List<int> bytes) {
    throw const ShouldNotBeCalledDataSourcePackageDataException(
      'RequestValueConverter.fromBytes()',
      'RequestValueBody is intended to be used only for outgoing packages, '
          'therefore only toBytes() method can be used',
    );
  }

  @override
  List<int> toBytes(RequestValueBody model) => [FunctionId.requestValue.value];
}
