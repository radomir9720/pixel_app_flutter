import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class MotorTemperatureIncomingDataSourcePackage
    extends DataSourceIncomingPackage<MotorTemperature>
    with
        IsEventOrBufferRequestOrSubscriptionAnswerRequestTypeMixin,
        IsPeriodicValueStatusFunctionIdMixin {
  MotorTemperatureIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isMotorTemperature;

  @override
  BytesConverter<MotorTemperature> get bytesConverter =>
      MotorTemperature.converter;
}
