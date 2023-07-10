import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

class MotorTemperatureIncomingDataSourcePackage
    extends TwoInt16WithStatusIncomingDataSourcePackage {
  MotorTemperatureIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isMotorTemperature;
}
