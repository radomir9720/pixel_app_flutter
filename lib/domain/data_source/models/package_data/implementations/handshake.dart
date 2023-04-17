import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/empty_body.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/wrappers/integer_wrapper.dart';

class HandshakeID extends IntegerWrapper {
  const HandshakeID(super.value);

  @override
  BytesConverter<HandshakeID> get bytesConverter =>
      const HandshakePingConverter();
}

class EmptyHandshakeBody extends EmptyBody {
  const EmptyHandshakeBody();

  @override
  BytesConverter<EmptyHandshakeBody> get bytesConverter =>
      const HandshakeInitializationConverter();
}

class HandshakeInitializationConverter
    extends EmptyBodyConverter<EmptyHandshakeBody> {
  const HandshakeInitializationConverter();

  @override
  EmptyHandshakeBody fromBytes(List<int> bytes) => const EmptyHandshakeBody();
}

class HandshakePingConverter extends IntegerWrapperConverter<HandshakeID> {
  const HandshakePingConverter() : super(fixedBytesLength: 4);

  @override
  HandshakeID fromBytes(List<int> bytes) {
    return HandshakeID(bytes.toIntFromInt32);
  }
}
