import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

class BatteryPowerIncomingDataSourcePackage
    extends Int16WithStatusIncomingDataSourcePackage {
  BatteryPowerIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isBatteryPower;
}
