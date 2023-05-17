import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_incoming_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

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
    extends SuccessEventUint8IncomingDataSourcePackage
    with _FrontHazardBeamParameterIdMixin
    implements FrontHazardBeamIncomingDataSourcePackage<SuccessEventUint8Body> {
  FrontHazardBeamSetIncomingDataSourcePackage(super.source);
}

class TailHazardBeamSetIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    with _TailHazardBeamParameterIdMixin
    implements TailHazardBeamIncomingDataSourcePackage<SuccessEventUint8Body> {
  TailHazardBeamSetIncomingDataSourcePackage(super.source);
}
