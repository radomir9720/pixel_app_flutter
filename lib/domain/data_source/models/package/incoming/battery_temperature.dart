import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/mixins/request_type_validation_mixins.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class BatteryTemperatureFirstBatchIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryTemperatureFirstBatch>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryTemperatureFirstBatchIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryTemperatureFirstBatch> get dataBytesToModelConverter =>
      BatteryTemperatureFirstBatchConverter();

  @override
  bool get validParameterId => parameterId.isTemperatureFirst;
}

class BatteryTemperatureSecondBatchIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryTemperatureSecondBatch>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryTemperatureSecondBatchIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryTemperatureSecondBatch> get dataBytesToModelConverter =>
      BatteryTemperatureSecondBatchConverter();

  @override
  bool get validParameterId => parameterId.isTemperatureSecond;
}

class BatteryTemperatureThirdBatchIncomingDataSourcePackage
    extends DataSourceIncomingPackage<BatteryTemperatureThirdBatch>
    with IsValueUpdateOrBufferRequestMixin {
  BatteryTemperatureThirdBatchIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<BatteryTemperatureThirdBatch> get dataBytesToModelConverter =>
      BatteryTemperatureThirdBatchConverter();

  @override
  bool get validParameterId => parameterId.isTemperatureThird;
}
