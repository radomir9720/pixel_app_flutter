import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class LowVoltageMinMaxDeltaIncomingDataSourcePackage
    extends DataSourceIncomingPackage<LowVoltageMinMaxDelta>
    with IsEventRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  LowVoltageMinMaxDeltaIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<LowVoltageMinMaxDelta> get bytesConverter =>
      const LowVoltageMinMaxDeltaConverter();

  @override
  bool get validParameterId => parameterId.isLowVoltageMinMaxDelta;
}
