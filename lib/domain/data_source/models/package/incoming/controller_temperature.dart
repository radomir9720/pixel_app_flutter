import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

class ControllerTemperatureIncomingDataSourcePackage
    extends TwoInt16WithStatusIncomingDataSourcePackage {
  ControllerTemperatureIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isControllerTemperature;
}
