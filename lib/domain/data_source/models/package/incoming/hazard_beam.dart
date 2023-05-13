import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/bytes_convertible.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/set_uint8_body.dart';

abstract class HazardBeamIncomingDataSourcePackage<T extends BytesConvertible>
    extends DataSourceIncomingPackage<T> {
  HazardBeamIncomingDataSourcePackage(super.source);
}

abstract class FrontHazardBeamIncomingDataSourcePackage<
    T extends BytesConvertible> extends HazardBeamIncomingDataSourcePackage<T> {
  FrontHazardBeamIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isFrontHazardBeam;
}

abstract class TailHazardBeamIncomingDataSourcePackage<
    T extends BytesConvertible> extends HazardBeamIncomingDataSourcePackage<T> {
  TailHazardBeamIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isTailHazardBeam;
}

mixin _FrontHazardBeamParameterIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validParameterId => parameterId.isFrontHazardBeam;
}

mixin _TailHazardBeamParameterIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validParameterId => parameterId.isTailHazardBeam;
}

class FrontHazardBeamSetIncomingDataSourcePackage
    extends SetUint8ResultIncomingDataSourcePackage
    with _FrontHazardBeamParameterIdMixin
    implements FrontHazardBeamIncomingDataSourcePackage<SetUint8ResultBody> {
  FrontHazardBeamSetIncomingDataSourcePackage(super.source);
}

class TailHazardBeamSetIncomingDataSourcePackage
    extends SetUint8ResultIncomingDataSourcePackage
    with _TailHazardBeamParameterIdMixin
    implements TailHazardBeamIncomingDataSourcePackage<SetUint8ResultBody> {
  TailHazardBeamSetIncomingDataSourcePackage(super.source);
}
