import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';

class MotorCurrentIncomingDataSourcePackage
    extends TwoInt16WithStatusIncomingDataSourcePackage {
  MotorCurrentIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isMotorCurrent;
}
