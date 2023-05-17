import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class LowBeamIncomingDataSourcePackage<T extends BytesConvertible>
    extends DataSourceIncomingPackage<T> {
  LowBeamIncomingDataSourcePackage(super.source);
}

mixin _LowBeamParameterIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validParameterId => parameterId.isLowBeam;
}

class LowBeamSetIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    with _LowBeamParameterIdMixin
    implements LowBeamIncomingDataSourcePackage<SuccessEventUint8Body> {
  LowBeamSetIncomingDataSourcePackage(super.source);
}
