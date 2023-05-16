import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';

class MotorSpeedIncomingDataSourcePackage
    extends TwoUint16WithStatusIncomingDataSourcePackage {
  MotorSpeedIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isMotorSpeed;
}
