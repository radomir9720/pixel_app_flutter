import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class OutgoingHandshakePackage extends DataSourceOutgoingPackage {
  OutgoingHandshakePackage({
    required super.parameterId,
    required HandshakeID handshakeId,
  }) : super(
          requestType: const DataSourceRequestType.handshake(),
          bytesConvertible: handshakeId,
        );
}

class OutgoingInitialHandshakePackage extends OutgoingHandshakePackage {
  OutgoingInitialHandshakePackage({
    required super.handshakeId,
  }) : super(parameterId: const DataSourceParameterId.custom(kParameterId));

  static const kParameterId = 0;
}

class OutgoingPingHandshakePackage extends OutgoingHandshakePackage {
  OutgoingPingHandshakePackage({
    required super.handshakeId,
  }) : super(parameterId: const DataSourceParameterId.custom(kParameterId));

  static const kParameterId = 0xFFFF;
}
