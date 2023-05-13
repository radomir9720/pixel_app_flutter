import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/handshake.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

abstract class HandshakeIncomingDataSourcePackage<T extends BytesConvertible>
    extends DataSourceIncomingPackage<T> {
  HandshakeIncomingDataSourcePackage(super.source);

  @override
  bool get validRequestType => requestType.isHandshake;

  @override
  bool get validFunctionId => true;
}

class HandshakeInitialIncomingDataSourcePackage
    extends HandshakeIncomingDataSourcePackage<EmptyHandshakeBody> {
  HandshakeInitialIncomingDataSourcePackage(super.source);

  @override
  bool get validParameterId =>
      parameterId.value == OutgoingInitialHandshakePackage.kParameterId;

  @override
  BytesConverter<EmptyHandshakeBody> get bytesConverter =>
      const HandshakeInitializationConverter();
}

class HandshakePingIncomingDataSourcePackage
    extends HandshakeIncomingDataSourcePackage<HandshakeID> {
  HandshakePingIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<HandshakeID> get bytesConverter =>
      const HandshakePingConverter();

  @override
  bool get validParameterId =>
      parameterId.value == OutgoingPingHandshakePackage.kParameterId;
}
