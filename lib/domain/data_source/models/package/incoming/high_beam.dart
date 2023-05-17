import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class HighBeamIncomingDataSourcePackage<T extends BytesConvertible>
    extends DataSourceIncomingPackage<T> {
  HighBeamIncomingDataSourcePackage(super.source);
}

mixin _HighBeamParameterIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validParameterId => parameterId.isHighBeam;
}

class HighBeamSetIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    with _HighBeamParameterIdMixin
    implements HighBeamIncomingDataSourcePackage<SuccessEventUint8Body> {
  HighBeamSetIncomingDataSourcePackage(super.source);
}
