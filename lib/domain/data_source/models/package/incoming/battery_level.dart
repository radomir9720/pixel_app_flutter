import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

class BatteryLevelIncomingDataSourcePackage
    extends Uint8WithStatusIncomingDataSourcePackage {
  BatteryLevelIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isBatteryLevel;
}
