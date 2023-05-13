import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/implementations/set_uint8_body.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class TurnSignalIncomingDataSourcePackage<T extends BytesConvertible>
    extends DataSourceIncomingPackage<T> {
  TurnSignalIncomingDataSourcePackage(super.source);
}

class FrontLeftTurnSignalIncomingDataSourcePackage
    extends SetUint8ResultIncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SetUint8ResultBody> {
  FrontLeftTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isFrontLeftTurnSignal;
}

class FrontRightTurnSignalIncomingDataSourcePackage
    extends SetUint8ResultIncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SetUint8ResultBody> {
  FrontRightTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isFrontRightTurnSignal;
}

class TailLeftTurnSignalIncomingDataSourcePackage
    extends SetUint8ResultIncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SetUint8ResultBody> {
  TailLeftTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isTailLeftTurnSignal;
}

class TailRightTurnSignalIncomingDataSourcePackage
    extends SetUint8ResultIncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SetUint8ResultBody> {
  TailRightTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isTailRightTurnSignal;
}
