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
    extends SetUint8ResultIncomingDataSourcePackage
    with _FrontSideBeamParameterIdMixin
    implements FrontSideBeamIncomingDataSourcePackage<SetUint8ResultBody> {
  FrontSideBeamSetIncomingDataSourcePackage(super.source);
}

class TailSideBeamSetIncomingDataSourcePackage
    extends SetUint8ResultIncomingDataSourcePackage
    with _TailSideBeamParameterIdMixin
    implements TailSideBeamIncomingDataSourcePackage<SetUint8ResultBody> {
  TailSideBeamSetIncomingDataSourcePackage(super.source);
}
