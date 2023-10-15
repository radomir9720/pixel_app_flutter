import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class CabinLightIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    implements DataSourceIncomingPackage<SuccessEventUint8Body> {
  CabinLightIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isCabinLight;
}
