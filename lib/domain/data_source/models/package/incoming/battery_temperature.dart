import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/function_id_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class BatteryTemperatureFirstBatchIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryTemperatureFirstBatch>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryTemperatureFirstBatchIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryTemperatureFirstBatch> get bytesConverter =>
      BatteryTemperatureFirstBatchConverter();

  @override
  bool get validParameterId => parameterId.isTemperatureFirst;
}

class BatteryTemperatureSecondBatchIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryTemperatureSecondBatch>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryTemperatureSecondBatchIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryTemperatureSecondBatch> get bytesConverter =>
      BatteryTemperatureSecondBatchConverter();

  @override
  bool get validParameterId => parameterId.isTemperatureSecond;
}

class BatteryTemperatureThirdBatchIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryTemperatureThirdBatch>
    with IsEventOrBufferRequestRequestTypeMixin, IsSuccessEventFunctionIdMixin {
  BatteryTemperatureThirdBatchIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryTemperatureThirdBatch> get bytesConverter =>
      BatteryTemperatureThirdBatchConverter();

  @override
  bool get validParameterId => parameterId.isTemperatureThird;
}
