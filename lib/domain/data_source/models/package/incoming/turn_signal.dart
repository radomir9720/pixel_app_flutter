import 'package:pixel_app_flutter/domain/data_source/models/package/data_source_package.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class TurnSignalIncomingDataSourcePackage<T extends BytesConvertible>
    extends DataSourceIncomingPackage<T> {
  TurnSignalIncomingDataSourcePackage(super.source);
}

class FrontLeftTurnSignalIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SuccessEventUint8Body> {
  FrontLeftTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isFrontLeftTurnSignal;
}

class FrontRightTurnSignalIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SuccessEventUint8Body> {
  FrontRightTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isFrontRightTurnSignal;
}

class TailLeftTurnSignalIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SuccessEventUint8Body> {
  TailLeftTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isTailLeftTurnSignal;
}

class TailRightTurnSignalIncomingDataSourcePackage
    extends SuccessEventUint8IncomingDataSourcePackage
    implements TurnSignalIncomingDataSourcePackage<SuccessEventUint8Body> {
  TailRightTurnSignalIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId => parameterId.isTailRightTurnSignal;
}
