import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef Observer = void Function(List<int> package);

abstract class DataSource {
  DataSource({required this.id}) : observers = {};

  final int id;

  final Set<Observer> observers;

  void addObserver(Observer observer) => observers.add(observer);

  void removeObserver(Observer observer) => observers.remove(observer);

  void observe(List<int> package) {
    for (final observer in observers) {
      observer(package);
    }
  }

  String get key;

  Stream<DataSourceIncomingEvent> get eventStream;

  Future<Result<SendEventError, void>> sendEvent(DataSourceOutgoingEvent event);

  Future<bool> get isEnabled;

  Future<bool> get isAvailable;

  Future<Result<EnableError, void>> enable();

  Future<Result<ConnectError, void>> connect(String address);

  Future<Result<DisconnectError, void>> disconnect();

  Future<Result<GetDeviceListError, Stream<DataSourceDevice>>>
      getDeviceStream();

  Future<Result<CancelDeviceDiscoveringError, void>> cancelDeviceDiscovering();

  @mustCallSuper
  Future<void> dispose() async {
    observers.clear();
  }
}

enum SendEventError { unknown, noConnection }

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
