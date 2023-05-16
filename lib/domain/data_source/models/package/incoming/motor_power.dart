import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';

class MotorPowerIncomingDataSourcePackage
    extends TwoInt16WithStatusIncomingDataSourcePackage {
  MotorPowerIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isMotorPower;
}
