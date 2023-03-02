import 'dart:async';

import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/default_data_source_observer_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/devices_periodic_stream_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/events_stream_controller_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/parse_bytes_package_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef ListUsbPortsCallback = List<String> Function();

class USBDataSource extends DataSource
    with
        DevicesPeriodicStreamMixin,
        ParseBytesPackageMixin,
        EventsStreamControllerMixin,
        DefaultDataSourceObserverMixin {
  USBDataSource({
    required super.id,
    required this.getAvailablePorts,
    this.portParametersConfig = const UsbPortParametersConfig(),
  });

  @protected
  final ListUsbPortsCallback getAvailablePorts;

  @protected
  final UsbPortParametersConfig portParametersConfig;

  @protected
  @visibleForTesting
  SerialPort? serialPort;

  @protected
  @visibleForTesting
  SerialPortReader? reader;

  StreamSubscription<void>? _readSubscription;

  static const kKey = 'usb';

  @override
  String get key => kKey;

  @override
  Future<Result<ConnectError, void>> connect(String address) async {
    final sp = SerialPort(address);
    final success = sp.openReadWrite();

    final config = SerialPortConfig()
      ..baudRate = portParametersConfig.baudRate
      ..bits = portParametersConfig.dataBits
      ..stopBits = portParametersConfig.stopBits
      ..parity = portParametersConfig.parity;
    sp.config = config;

    if (success) {
      serialPort = sp;
      final r = SerialPortReader(sp);
      reader = r;

      _readSubscription = r.stream.listen((rawPackage) {
        onNewPackage(
          rawPackage: rawPackage,
          onNewEventCallback: controller.add,
        );
      });

      return const Result.value(null);
    }

    return const Result.error(ConnectError.unknown);
  }

  @override
  Future<Result<SendEventError, void>> sendEvent(
    DataSourceOutgoingEvent event,
  ) async {
    final sp = serialPort;
    if (sp == null || !sp.isOpen) {
      return const Result.error(SendEventError.noConnection);
    }

    final package = event.toPackage();

    observe(package);

    sp.write(package);

    return const Result.value(null);
  }

  @override
  Future<Result<EnableError, void>> enable() async {
    return const Result.value(null);
  }

  @override
  Stream<DataSourceIncomingEvent> get eventStream => controller.stream;

  @override
  Future<Result<GetDeviceListError, Stream<List<DataSourceDevice>>>>
      getDevicesStream() async {
    final stream = getDevicePeriodicStream<String>(
      getDevices: () async => getAvailablePorts(),
      mapToDataSourceDevice: (address) {
        return DataSourceDevice(
          address: address,
          name: SerialPort(address).description,
        );
      },
    );

    return Result.value(stream);
  }

  @override
  Future<bool> get isAvailable async => true;

  @override
  Future<bool> get isEnabled async => true;

  @override
  Future<Result<DisconnectError, void>> disconnect() async {
    reader?.close();
    await _readSubscription?.cancel();
    reader = null;
    _readSubscription = null;
    final success = serialPort?.close() ?? true;

    if (success) {
      serialPort?.dispose();
      serialPort = null;
      return const Result.value(null);
    }

    return const Result.error(DisconnectError.unknown);
  }

  @override
  Future<void> dispose() async {
    await disconnect();
    return super.dispose();
  }
}
