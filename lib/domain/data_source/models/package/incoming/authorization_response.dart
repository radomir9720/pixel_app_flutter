import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';

class AuthorizationInitializationResponseIncomingDataSourcePackage
    extends DataSourceIncomingPackage<AuthorizationInitializationResponse> {
  AuthorizationInitializationResponseIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<AuthorizationInitializationResponse> get bytesConverter =>
      const AuthorizationInitializationResponseConverter();

  @override
  bool get validFunctionId =>
      data[0] == AuthorizationFunctionId.initializationResponseId;

  @override
  bool get validParameterId => parameterId.isAuthorization;

  @override
  bool get validRequestType => requestType.isHandshake;
}

class AuthorizationResponseIncomingDataSourcePackage
    extends DataSourceIncomingPackage<AuthorizationResponse> {
  AuthorizationResponseIncomingDataSourcePackage(super.source);

  @override
  BytesConverter<AuthorizationResponse> get bytesConverter =>
      const AuthorizationResponseConverter();

  @override
  bool get validFunctionId => data[0] == AuthorizationFunctionId.responseId;

  @override
  bool get validParameterId => parameterId.isAuthorization;

  @override
  bool get validRequestType => requestType.isHandshake;
}
