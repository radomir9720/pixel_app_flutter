import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class HighBeamSetIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    implements DataSourceIncomingPackage<SuccessEventUint8Body> {
  HighBeamSetIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isHighBeam;
}
