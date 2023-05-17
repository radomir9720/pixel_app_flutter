import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class SideBeamIncomingDataSourcePackage<T extends BytesConvertible>
    extends DataSourceIncomingPackage<T> {
  SideBeamIncomingDataSourcePackage(super.source);
}

abstract class FrontSideBeamIncomingDataSourcePackage<
    T extends BytesConvertible> extends SideBeamIncomingDataSourcePackage<T> {
  FrontSideBeamIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isFrontSideBeam;
}

abstract class TailSideBeamIncomingDataSourcePackage<T extends BytesConvertible>
    extends SideBeamIncomingDataSourcePackage<T> {
  TailSideBeamIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isTailSideBeam;
}

mixin _FrontSideBeamParameterIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validParameterId => parameterId.isFrontSideBeam;
}

mixin _TailSideBeamParameterIdMixin<T extends BytesConvertible>
    on DataSourceIncomingPackage<T> {
  @override
  bool get validParameterId => parameterId.isTailSideBeam;
}

class FrontSideBeamSetIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    with _FrontSideBeamParameterIdMixin
    implements FrontSideBeamIncomingDataSourcePackage<SuccessEventUint8Body> {
  FrontSideBeamSetIncomingDataSourcePackage(super.source);
}

class TailSideBeamSetIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    with _TailSideBeamParameterIdMixin
    implements TailSideBeamIncomingDataSourcePackage<SuccessEventUint8Body> {
  TailSideBeamSetIncomingDataSourcePackage(super.source);
}
