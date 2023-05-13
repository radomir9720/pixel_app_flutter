import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class ErrorWithCodeAndSectionIncomingDataSourcePackage
    extends DataSourceIncomingPackage<ErrorWithCodeAndSectionPackageData>
    with IsEventRequestTypeMixin {
  ErrorWithCodeAndSectionIncomingDataSourcePackage(super.source);

  @override
  bool get validFunctionId =>
      data.isNotEmpty && data[0] == FunctionId.errorEventId;

  @override
  bool get validParameterId => true;

  @override
  BytesConverter<ErrorWithCodeAndSectionPackageData> get bytesConverter =>
      const ErrorWithCodeAndSectionConverter();
}
