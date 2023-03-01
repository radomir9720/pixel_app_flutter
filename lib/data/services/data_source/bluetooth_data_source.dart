import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/cached_devices_stream_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/default_data_source_observer_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/events_stream_controller_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/parse_bytes_package_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef GetBluetoothConnectionCallback = Future<BluetoothConnection> Function(
  String address,
);

class BluetoothDataSource extends DataSource
    with
        ParseBytesPackageMixin,
        CachedDevicesStreamMixin,
        EventsStreamControllerMixin,
        DefaultDataSourceObserverMixin {
  BluetoothDataSource({
    required super.id,
    required this.bluetoothSerial,
    required this.connectToAddress,
  });

  @visibleForTesting
  final GetBluetoothConnectionCallback connectToAddress;

  @visibleForTesting
  StreamSubscription<Uint8List>? subscription;

  @visibleForTesting
  StreamSink<Uint8List>? sink;

  @visibleForTesting
  final FlutterBluetoothSerial bluetoothSerial;

  @visibleForTesting
  BluetoothConnection? connection;

  static const kKey = 'bluetooth';

  @override
  String get key => kKey;

  @override
  Stream<DataSourceIncomingEvent> get eventStream => controller.stream;

  @override
  Future<Result<SendEventError, void>> sendEvent(
    DataSourceOutgoingEvent event,
  ) async {
    final _sink = sink;
    if (_sink == null) {
      return const Result.error(SendEventError.noConnection);
    }

    final package = event.toPackage();

    observe(package);

    _sink.add(package);

    return const Result.value(null);
  }

  @override
  Future<Result<EnableError, void>> enable() async {
    if (!await isAvailable) {
      return const Result.error(EnableError.isUnavailable);
    }

    if (await isEnabled) {
      return const Result.error(EnableError.isAlreadyEnabled);
    }

    final enabled = await bluetoothSerial.requestEnable() ?? false;

    if (enabled) return const Result.value(null);

    return const Result.error(EnableError.unsuccessfulEnableAttempt);
  }

  @override
  Future<bool> get isEnabled =>
      bluetoothSerial.isEnabled.then((value) => value ?? false);

  @override
  Future<bool> get isAvailable =>
      bluetoothSerial.isAvailable.then((value) => value ?? false);

  @override
  Future<Result<ConnectError, void>> connect(String address) async {
    final bondedDevices = await bluetoothSerial.getBondedDevices();

    if (!bondedDevices.map((e) => e.address).contains(address)) {
      final bonded = await bluetoothSerial.bondDeviceAtAddress(address);
      if (!(bonded ?? false)) {
        return const Result.error(ConnectError.bondingError);
      }
    }

    final connection = await connectToAddress(address);
    this.connection = connection;

    final input = connection.input;
    final sink = connection.output;

    // Closing current sink and assigning the new one
    await this.sink?.close();
    this.sink = null;
    this.sink = sink;

    if (input == null) {
      return const Result.error(ConnectError.unableToSubscribe);
    }

    // Cancelling current subscription and creating new one
    await subscription?.cancel();
    subscription = null;
    subscription = input.listen(
      (rawPackage) => onNewPackage(
        rawPackage: rawPackage,
        onNewEventCallback: controller.add,
      ),
    );

    return const Result.value(null);
  }

  @override
  Future<Result<CancelDeviceDiscoveringError, void>>
      cancelDeviceDiscovering() async {
    return Result.value(await bluetoothSerial.cancelDiscovery());
  }

  @override
  Future<Result<GetDeviceListError, Stream<List<DataSourceDevice>>>>
      getDevicesStream() async {
    final stream = getCachedDevicesStream<BluetoothDiscoveryResult>(
      devicesStream: bluetoothSerial.startDiscovery(),
      mapToDataSourceDevice: (event) => DataSourceDevice(
        name: event.device.name,
        address: event.device.address,
        isBonded: event.device.isBonded,
      ),
    );

    return Result.value(stream);
  }

  @override
  Future<void> dispose() async {
    await super.dispose();

    await subscription?.cancel();
    subscription = null;
    //
    await sink?.close();
    sink = null;
    //
    await connection?.close();
    connection?.dispose();
  }

  @override
  Future<Result<DisconnectError, void>> disconnect() async {
    await connection?.close();
    return const Result.value(null);
  }
}
