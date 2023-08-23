import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class CustomIncomingDataSourcePackage
    extends DataSourceIncomingPackage<PlainBytesConvertible> {
  CustomIncomingDataSourcePackage(
    super.source, {
    this.validFunctionIdCallback,
    this.validParameterIdCallback,
    this.valudRequestTypeCallback,
  });

  @protected
  final bool Function(int? functionId)? validFunctionIdCallback;

  @protected
  final bool Function(DataSourceParameterId parameterId)?
      validParameterIdCallback;

  @protected
  final bool Function(DataSourceRequestType requestType)?
      valudRequestTypeCallback;

  @override
  BytesConverter<PlainBytesConvertible> get bytesConverter =>
      const PlainBytesConvertibleConverter();

  @override
  bool get validFunctionId =>
      validFunctionIdCallback?.call(data.isNotEmpty ? data[0] : null) ?? true;

  @override
  bool get validParameterId =>
      validParameterIdCallback?.call(parameterId) ?? true;

  @override
  bool get validRequestType =>
      valudRequestTypeCallback?.call(requestType) ?? true;
}
