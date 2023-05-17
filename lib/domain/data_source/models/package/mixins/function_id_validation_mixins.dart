import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/data_source_package_data_exceptions.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

mixin IsPeriodicValueStatusFunctionIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validFunctionId =>
      data.isNotEmpty && PeriodicValueStatus.isValid(data[0]);
}

mixin IsSuccessEventFunctionIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validFunctionId =>
      data.isNotEmpty && data[0] == FunctionId.okEventId;
}

mixin IsSetResponseFunctionIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  static const kSetResponseFunctionIds = [
    FunctionId.successSetValueWithParamId,
    FunctionId.errorSettingValueWithParamId
  ];

  @override
  bool get validFunctionId =>
      data.isNotEmpty && kSetResponseFunctionIds.contains(data[0]);

  R whenFunctionId<R>({
    required R Function(List<int> data) error,
    required R Function(List<int> data) success,
  }) {
    final functionId = data.isEmpty ? null : data[0];
    final _data = data.isEmpty ? <int>[] : data.sublist(1);
    switch (functionId) {
      case FunctionId.successSetValueWithParamId:
        return success(_data);
      case FunctionId.errorSettingValueWithParamId:
        return error(_data);
      default:
        throw UnexpectedFunctionIdDataSourcePackageDataException(
          expected: kSetResponseFunctionIds,
          functionId: functionId,
          package: this,
        );
    }
  }
}
