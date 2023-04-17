import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class MaxTemperatureIncomingDataSourcePackage
    extends DataSourceIncomingPackage<MaxTemperature>
    with IsValueUpdateOrBufferRequestOrSubscriptionAnswerMixin {
  MaxTemperatureIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<MaxTemperature> get dataBytesToModelConverter =>
      const MaxTemperatureConverter();

  @override
  bool get validParameterId => parameterId.isMaxTemperature;
}
