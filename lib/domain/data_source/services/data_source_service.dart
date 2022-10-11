import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class DataSource {
  const DataSource();

  String get key;

  Stream<DataSourceIncomingEvent> get eventStream;

  Future<Result<SendEventError, void>> sendEvent(DataSourceOutgoingEvent event);

  Future<bool> get isEnabled;

  Future<bool> get isAvailable;

  Future<Result<EnableError, void>> enable();

  Future<Result<ConnectError, void>> connect(String address);

  Future<Result<GetDeviceListError, Stream<DataSourceDevice>>>
      getDeviceStream();

  Future<Result<CancelDeviceDiscoveringError, void>> cancelDeviceDiscovering();

  Future<void> dispose();
}

enum SendEventError { unknown, noConnection }

enum ConnectError { unknown, bondingError, unableToSubscribe }

enum GetDeviceListError { unknown }

enum CancelDeviceDiscoveringError { unknown }

enum EnableError {
  unknown,
  isAlreadyEnabled,
  isUnavailable,
  unsuccessfulEnableAttempt;

  R when<R>({
    required R Function() unknown,
    required R Function() isAlreadyEnabled,
    required R Function() isUnavailable,
    required R Function() unsuccessfulEnableAttempt,
  }) {
    switch (this) {
      case EnableError.unknown:
        return unknown();
      case EnableError.isAlreadyEnabled:
        return isAlreadyEnabled();
      case EnableError.isUnavailable:
        return isUnavailable();
      case EnableError.unsuccessfulEnableAttempt:
        return unsuccessfulEnableAttempt();
    }
  }
}
