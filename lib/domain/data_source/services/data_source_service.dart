import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef Observer = void Function(
  Observerable<dynamic> observable,
);

abstract class DataSource {
  DataSource({required this.id});

  final int id;

  void addObserver(Observer observer);

  void removeObserver(Observer observer);

  void observe(Observerable<dynamic> observable);

  String get key;

  Stream<DataSourceIncomingPackage> get packageStream;

  Future<Result<SendPackageError, void>> sendPackage(
    DataSourceOutgoingPackage package,
  );

  Future<Result<SendPackageError, void>> sendPackages(
    List<DataSourceOutgoingPackage> packages,
  );

  Future<bool> get isEnabled;

  Future<bool> get isAvailable;

  Future<Result<EnableError, void>> enable();

  Future<Result<ConnectError, void>> connect(String address);

  Future<Result<DisconnectError, void>> disconnect();

  Future<Result<GetDeviceListError, Stream<List<DataSourceDevice>>>>
      getDevicesStream();

  Future<Result<CancelDeviceDiscoveringError, void>> cancelDeviceDiscovering();

  @mustCallSuper
  Future<void> dispose() async {}
}

enum SendPackageError { unknown, noConnection }

enum ConnectError { unknown, bondingError, unableToSubscribe }

enum DisconnectError { unknown }

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

@immutable
sealed class Observerable<T> {
  const Observerable(this.data);

  final T data;

  R? whenOrNull<R>({
    R Function(List<int> bytes)? rawIncomingBytes,
    R Function(List<int> bytes)? rawIncomingPackage,
    R Function(DataSourceOutgoingPackage package)? outgoingPackage,
    R Function(DataSourceIncomingPackage<dynamic> package)? incomingPackage,
  }) {
    return switch (this) {
      RawIncomingBytesObservable(data: final List<int> bytes) =>
        rawIncomingBytes?.call(bytes),
      RawIncomingPackageObservable(data: final List<int> bytes) =>
        rawIncomingPackage?.call(bytes),
      OutgoingPackageObservable(data: final DataSourceOutgoingPackage bytes) =>
        outgoingPackage?.call(bytes),
      ParsedIncomingPackageObservable(
        data: final DataSourceIncomingPackage<dynamic> bytes
      ) =>
        incomingPackage?.call(bytes),
    };
  }
}

final class RawIncomingBytesObservable extends Observerable<List<int>> {
  const RawIncomingBytesObservable(super.data);
}

final class OutgoingPackageObservable
    extends Observerable<DataSourceOutgoingPackage> {
  const OutgoingPackageObservable(super.data);
}

final class ParsedIncomingPackageObservable
    extends Observerable<DataSourceIncomingPackage<dynamic>> {
  const ParsedIncomingPackageObservable(super.data);
}

final class RawIncomingPackageObservable extends Observerable<List<int>> {
  const RawIncomingPackageObservable(super.data);
}
