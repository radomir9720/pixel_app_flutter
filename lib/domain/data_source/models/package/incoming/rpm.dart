import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';

class RPMIncomingDataSourcePackage
    extends TwoUint16WithStatusIncomingDataSourcePackage {
  RPMIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isRPM;
}
