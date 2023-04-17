import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class LowVoltageMinMaxDeltaIncomingDataSourcePackage
    extends DataSourceIncomingPackage<LowVoltageMinMaxDelta> {
  LowVoltageMinMaxDeltaIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<LowVoltageMinMaxDelta> get dataBytesToModelConverter =>
      const LowVoltageMinMaxDeltaConverter();

  @override
  bool get validParameterId =>
      parameterId == const DataSourceParameterId.lowVoltageMinMaxDelta();

  @override
  bool get validRequestType => requestType.isValueUpdate;
}
