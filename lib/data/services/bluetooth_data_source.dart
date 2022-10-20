import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

class BluetoothDataSource extends DataSource {
  BluetoothDataSource({
    required this.bluetoothSerial,
    required super.id,
  })  : controller = StreamController.broadcast(),
        package = [];

  @visibleForTesting
  final StreamController<DataSourceIncomingEvent> controller;

  @visibleForTesting
  StreamSubscription<Uint8List>? subscription;

  @visibleForTesting
  StreamSink<Uint8List>? sink;

  List<int> package;

  @protected
  final FlutterBluetoothSerial bluetoothSerial;

  BluetoothConnection? connection;

  static const startingByte = 0x3c;
  static const endingByte = 0x3e;

  @override
  String get key => 'bluetooth';

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
    if (!(await bluetoothSerial.isAvailable ?? false)) {
      return const Result.error(EnableError.isUnavailable);
    }

    if (await bluetoothSerial.isEnabled ?? false) {
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

    final connection = await BluetoothConnection.toAddress(address);
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
    subscription = input.listen(_onNewPackage);

    return const Result.value(null);
  }

  void _onNewPackage(Uint8List event) {
    observe(event);

    final incomingPackage = [...event];

    void parsePackage() {
      final _package = [...package];
      package.clear();

      final dataSourceEvent =
          DataSourceEvent.fromPackage(DataSourcePackage(_package));
      controller.sink.add(dataSourceEvent);
    }

    while (incomingPackage.isNotEmpty) {
      final initial = [...incomingPackage];

      final indexOfStartingByte = incomingPackage.indexOf(startingByte);
      final indexOfEndingByte = incomingPackage.indexOf(endingByte);
      final sublistFrom = indexOfStartingByte == -1 ? 0 : indexOfStartingByte;
      final sublistTo = indexOfEndingByte == -1
          ? incomingPackage.length
          : indexOfEndingByte + 1;

      if (package.isNotEmpty &&
          incomingPackage.contains(startingByte) &&
          incomingPackage.contains(endingByte) &&
          indexOfStartingByte < indexOfEndingByte) {
        // If current package has no ending byte, and inside
        // the incoming package the ending byte is after the starting byte -
        // resetting current package(clearing)
        package.clear();
      }

      if (incomingPackage.contains(startingByte) || package.isNotEmpty) {
        package.addAll(
          incomingPackage.sublist(sublistFrom, sublistTo),
        );
        incomingPackage.removeRange(0, sublistTo);
        if (package.isNotEmpty && package.last == endingByte) {
          parsePackage();
        }
      }

      if (const DeepCollectionEquality().equals(initial, incomingPackage)) {
        break;
      }
    }
  }

  @override
  Future<Result<CancelDeviceDiscoveringError, void>>
      cancelDeviceDiscovering() async {
    return Result.value(await bluetoothSerial.cancelDiscovery());
  }

  @override
  Future<Result<GetDeviceListError, Stream<DataSourceDevice>>>
      getDeviceStream() async {
    final stream = bluetoothSerial.startDiscovery().map(
          (event) => DataSourceDevice(
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
    await controller.close();
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
