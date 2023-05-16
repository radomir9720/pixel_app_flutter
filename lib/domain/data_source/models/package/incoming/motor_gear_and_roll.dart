import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class MotorGearAndRollIncomingDataSourcePackage
    extends DataSourceIncomingPackage<MotorGearAndRoll>
    with
        IsEventOrBufferRequestOrSubscriptionAnswerRequestTypeMixin,
        IsPeriodicValueStatusFunctionIdMixin {
  MotorGearAndRollIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<MotorGearAndRoll> get bytesConverter =>
      MotorGearAndRoll.converter;

  @override
  bool get validParameterId => parameterId.isGearAndRoll;
}
