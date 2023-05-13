import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/set_uint8_body.dart';

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
    extends SetUint8ResultIncomingDataSourcePackage
    with _HighBeamParameterIdMixin
    implements HighBeamIncomingDataSourcePackage<SetUint8ResultBody> {
  HighBeamSetIncomingDataSourcePackage(super.source);
}
