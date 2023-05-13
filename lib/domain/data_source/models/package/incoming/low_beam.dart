import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/set_uint8_body.dart';

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
    extends SetUint8ResultIncomingDataSourcePackage
    with _LowBeamParameterIdMixin
    implements LowBeamIncomingDataSourcePackage<SetUint8ResultBody> {
  LowBeamSetIncomingDataSourcePackage(super.source);
}
