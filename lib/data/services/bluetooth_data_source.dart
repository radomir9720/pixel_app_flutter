import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

extension PopFirstExtension on List<int> {
  List<int> popFirst(int count) {
    if (length == 0 || count == 0) return const [];
    if (count >= length) {
      final buffer = [...this];
      clear();
      return buffer;
    }

    final buffer = sublist(0, count);
    removeRange(0, count);
    return buffer;
  }
}

class BluetoothDataSource extends DataSource {
  BluetoothDataSource({
    required this.bluetoothSerial,
    required super.id,
    required this.connectToAddress,
    int parseDebouncerDelayInMillis = kParseDebouncerDelayInMillis,
  })  : controller = StreamController.broadcast(),
        buffer = [],
        debouncer = Debouncer(milliseconds: parseDebouncerDelayInMillis);

  @visibleForTesting
  static const kParseDebouncerDelayInMillis = 150;

  @visibleForTesting
  final StreamController<DataSourceIncomingEvent> controller;

  @visibleForTesting
  final Future<BluetoothConnection> Function(String address) connectToAddress;

  @visibleForTesting
  StreamSubscription<Uint8List>? subscription;

  @visibleForTesting
  StreamSink<Uint8List>? sink;

  @visibleForTesting
  final FlutterBluetoothSerial bluetoothSerial;

  @visibleForTesting
  BluetoothConnection? connection;

  @visibleForTesting
  List<int> buffer;

  @visibleForTesting
  final Debouncer debouncer;

  @visibleForTesting
  Completer<void>? noBytesInBufferCompleter;

  @override
  String get key => 'bluetooth';

  @override
  Stream<DataSourceIncomingEvent> get eventStream => controller.stream;

  Future<void> get noBytesInBufferFuture =>
      noBytesInBufferCompleter?.future ?? Future.value();

  bool get noBytesInBuffer => noBytesInBufferCompleter?.isCompleted ?? true;

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
    subscription = input.listen(_onNewPackage);

    return const Result.value(null);
  }

  void _onNewPackage(Uint8List event) {
    observe(event);

    buffer.addAll(event);

    tryParse();
  }

  @visibleForTesting
  void tryParse() {
    if (buffer.isEmpty) return;
    if (noBytesInBuffer) noBytesInBufferCompleter = Completer();

    const minimumPackageLength = 9;

    const startingByte = DataSourcePackage.startingByte;
    const endingByte = DataSourcePackage.endingByte;

    // Step 1
    // Check buffer lenght. Minimum length of a valid package is 9.
    // If the length is less than this value, do nothing(wait for more bytes).
    if (buffer.length < minimumPackageLength) return;

    // Step 2
    // If first byte is not starting,
    // then removing every byte until the starting one
    if (buffer.first != startingByte) {
      final indexOfStartingByte = buffer.indexOf(startingByte);

      // There is no starting byte in buffer yet
      // Clearing buffer
      if (indexOfStartingByte == -1) {
        buffer.removeRange(0, buffer.length);
        return;
      }

      // Starting byte was found
      // Removing every byte until starting byte(exclusive)
      buffer.popFirst(indexOfStartingByte);

      // Check the buffer lenght after popFirst() method.
      // If the length is less than minimum length, do nothing
      // (wait for more bytes).
      // ignore: invariant_booleans
      if (buffer.length < minimumPackageLength) return;
    }

    // Step 3
    // Check that buffer contains ending byte.
    // Otherwise do nothing(wait for more bytes)
    if (!buffer.contains(endingByte)) return;

    // Step 4
    // Checking buffer length
    // Correct bytes order:
    // 0 - starting byte
    // 1 - config byte 1
    // 2 - config byte 2
    // 3 - parameter id(first byte)
    // 4 - parameter id(second byte)
    // 5 - data length
    // 6+n - data
    // 6+n+1 - CRC sum(first byte)
    // 6+n+2 - CRC sum(second byte)
    // 6+n+3 - ending byte
    // So the ending byte should be at position bytes[5 + bytes[5] + 3]
    final indexOfPotentialEndingByte = 5 + buffer[5] + 3;
    // If length of the buffer is less than should be,
    // do nothing((wait for more bytes))
    if (indexOfPotentialEndingByte > buffer.length - 1) return;

    // Step 5
    // Check that ending byte is in the right position

    final potentialEndingByte = buffer[indexOfPotentialEndingByte];
    // If the ending byte is in the right position, then extracting the chunk
    // from buffer, parsing it, and adding to events stream
    if (potentialEndingByte == endingByte) {
      final package = buffer.popFirst(indexOfPotentialEndingByte + 1);
      final dataSourceEvent =
          DataSourceEvent.fromPackage(DataSourcePackage(package));
      controller.sink.add(dataSourceEvent);
    } else {
      // If the ending byte was not found at the index where it should be,
      // then trying to find the next starting byte, and remove everything until
      // the new starting byte(exclusive)
      final indexOfStartingByte = buffer.sublist(1).indexOf(startingByte);

      // There is no starting byte in buffer yet
      // Clearing buffer
      if (indexOfStartingByte == -1) {
        buffer.removeRange(0, buffer.length);
        return;
      }

      // Starting byte was found
      // Removing every byte until starting byte(exclusive)
      // + 1 because above we took a sublist of buffer, which begins
      // from second item
      buffer.popFirst(indexOfStartingByte + 1);
    }

    if (buffer.isNotEmpty) {
      debouncer.run(tryParse);
    } else {
      noBytesInBufferCompleter?.complete();
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
    debouncer.dispose();
    //
    if (!noBytesInBuffer) {
      noBytesInBufferCompleter?.complete();
    }
    //
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
