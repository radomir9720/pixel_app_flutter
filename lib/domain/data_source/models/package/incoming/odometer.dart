import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';

class OdometerIncomingDataSourcePackage
    extends Uint32WithStatusIncomingDataSourcePackage {
  OdometerIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isOdometer;
}
