import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';

class MotorVoltageIncomingDataSourcePackage
    extends TwoUint16WithStatusIncomingDataSourcePackage {
  MotorVoltageIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isMotorVoltage;
}
