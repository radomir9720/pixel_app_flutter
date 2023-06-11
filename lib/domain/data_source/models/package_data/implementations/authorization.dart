import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/extensions/int.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/data_source_package_data_exceptions.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

// Initialization Request
@immutable
class AuthorizationInitializationRequest extends BytesConvertible {
  const AuthorizationInitializationRequest();

  @override
  BytesConverter<AuthorizationInitializationRequest> get bytesConverter =>
      const AuthorizationInitializationRequestConverter();

  @override
  List<Object?> get props => [];
}

@immutable
class AuthorizationInitializationRequestConverter
    extends BytesConverter<AuthorizationInitializationRequest> {
  const AuthorizationInitializationRequestConverter();

  @override
  AuthorizationInitializationRequest fromBytes(List<int> bytes) {
    throw const FromBytesShouldNotBeCalledDataSourcePackageDataException(
      'AuthorizationInitializationRequestConverter',
    );
  }

  @override
  List<int> toBytes(AuthorizationInitializationRequest model) {
    return [FunctionId.authorizationInitializationRequestId];
  }
}

// Initialization Response
@immutable
class AuthorizationInitializationResponse extends BytesConvertible {
  const AuthorizationInitializationResponse({
    required this.method,
    required this.deviceId,
  });

  final int method;
  final List<int> deviceId;

  @override
  BytesConverter<AuthorizationInitializationResponse> get bytesConverter =>
      const AuthorizationInitializationResponseConverter();

  @override
  List<Object?> get props => [method, deviceId];
}

@immutable
class AuthorizationInitializationResponseConverter
    extends BytesConverter<AuthorizationInitializationResponse> {
  const AuthorizationInitializationResponseConverter();

  @override
  AuthorizationInitializationResponse fromBytes(List<int> bytes) {
    return AuthorizationInitializationResponse(
      method: bytes[1],
      deviceId: bytes.sublist(2),
    );
  }

  @override
  List<int> toBytes(AuthorizationInitializationResponse model) {
    return [
      FunctionId.authorizationInitializationResponseId,
      model.method,
      ...model.deviceId,
    ];
  }
}

// Authorization Request
@immutable
class AuthorizationRequest extends BytesConvertible {
  const AuthorizationRequest({required this.sn});

  // Serial number
  final List<int> sn;

  @override
  BytesConverter<AuthorizationRequest> get bytesConverter =>
      const AuthorizationRequestConverter();

  @override
  List<Object?> get props => [sn];
}

@immutable
class AuthorizationRequestConverter
    extends BytesConverter<AuthorizationRequest> {
  const AuthorizationRequestConverter();

  @override
  AuthorizationRequest fromBytes(List<int> bytes) {
    throw const FromBytesShouldNotBeCalledDataSourcePackageDataException(
      'AuthorizationRequestConverter',
    );
  }

  @override
  List<int> toBytes(AuthorizationRequest model) {
    final key = List.generate(16, (index) => Random().nextInt(0x100));
    final hash = sha1.convert([...model.sn, ...key]);
    return [
      FunctionId.authorizationRequestId,
      // Authorization method
      0x01,
      // key
      ...key,
      // hash
      ...hash.bytes,
    ];
  }
}

// Authorization Response
@immutable
class AuthorizationResponse extends BytesConvertible {
  const AuthorizationResponse({
    required this.success,
    required this.uptime,
  });

  final bool success;
  final Duration uptime;

  @override
  BytesConverter<AuthorizationResponse> get bytesConverter =>
      const AuthorizationResponseConverter();

  @override
  List<Object?> get props => [success, uptime];
}

@immutable
class AuthorizationResponseConverter
    extends BytesConverter<AuthorizationResponse> {
  const AuthorizationResponseConverter();
  @override
  AuthorizationResponse fromBytes(List<int> bytes) {
    return AuthorizationResponse(
      success: bytes[1] == 1,
      uptime: Duration(milliseconds: bytes.sublist(2).toIntFromUint32),
    );
  }

  @override
  List<int> toBytes(AuthorizationResponse model) {
    return [
      FunctionId.authorizationResponseId,
      if (model.success) 1 else 0,
      ...model.uptime.inMilliseconds.toBytesUint32,
    ];
  }
}
