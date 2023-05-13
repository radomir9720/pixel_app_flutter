import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/default_data_source_observer_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/devices_periodic_stream_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/package_stream_controller_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/parse_bytes_package_mixin.dart';
import 'package:pixel_app_flutter/data/services/data_source/mixins/send_packages_mixin.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:usb_serial/usb_serial.dart';

extension on UsbDevice {
  bool equalsTo(AndroidUsbDeviceData deviceData) {
    return deviceData.pid == pid &&
        deviceData.vid == vid &&
        deviceData.deviceName == deviceName;
  }
}

typedef ListUsbDevicesCallback = Future<List<UsbDevice>> Function();

class USBAndroidDataSource extends DataSource
    with
        DevicesPeriodicStreamMixin,
        ParseBytesPackageMixin,
        PackageStreamControllerMixin,
        DefaultDataSourceObserverMixin,
        SendPackagesMixin {
  USBAndroidDataSource({
    required super.id,
    required this.listDevices,
    this.portParametersConfig = const UsbPortParametersConfig(),
  });

  @protected
  final ListUsbDevicesCallback listDevices;

  @protected
  final UsbPortParametersConfig portParametersConfig;

  @protected
  @visibleForTesting
  UsbDevice? usbDevice;

  StreamSubscription<void>? _readSubscription;

  static const kKey = 'usb_android';

  @override
  Future<Result<ConnectError, void>> connect(String address) async {
    final usbData = AndroidUsbDeviceData.fromJson(address);
    final devices = await listDevices();

    UsbDevice? device;
    for (final e in devices) {
      if (e.equalsTo(usbData)) {
        device = e;
        break;
      }
    }

    if (device == null) return const Result.error(ConnectError.unknown);

    final port = await device.create();

    if (port == null || !await port.open()) {
      return const Result.error(ConnectError.bondingError);
    }

    await port.setPortParameters(
      portParametersConfig.baudRate,
      portParametersConfig.dataBits,
      portParametersConfig.stopBits,
      portParametersConfig.parity,
    );

    usbDevice = device;

    _readSubscription = port.inputStream?.listen((rawPackage) {
      onNewPackage(
        rawPackage: rawPackage,
        onNewPackageCallback: controller.add,
      );
    });

    return const Result.value(null);
  }

  @override
  Future<Result<SendPackageError, void>> sendPackage(
    DataSourceOutgoingPackage package,
  ) async {
    final port = usbDevice?.port;

    if (port == null) {
      return const Result.error(SendPackageError.noConnection);
    }

    observeOutgoing(package);

    await port.write(package.toUint8List);

    return const Result.value(null);
  }

  @override
  Stream<DataSourceIncomingPackage> get packageStream => controller.stream;

  @override
  Future<Result<GetDeviceListError, Stream<List<DataSourceDevice>>>>
      getDevicesStream() async {
    final stream = getDevicePeriodicStream<UsbDevice>(
      getDevices: listDevices,
      mapToDataSourceDevice: (device) {
        final usbData = AndroidUsbDeviceData(
          pid: device.pid,
          vid: device.vid,
          deviceId: device.deviceId,
          deviceName: device.deviceName,
          productName: device.productName,
        );

        return DataSourceDevice(
          address: usbData.toJson(),
          name: usbData.productName,
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
  String get key => kKey;

  @override
  Future<Result<DisconnectError, void>> disconnect() async {
    await _readSubscription?.cancel();
    _readSubscription = null;

    final success = await usbDevice?.port?.close() ?? true;

    if (success) {
      usbDevice = null;

      return const Result.value(null);
    }

    return const Result.error(DisconnectError.unknown);
  }

  @override
  Future<Result<EnableError, void>> enable() async {
    return const Result.value(null);
  }

  @override
  Future<void> dispose() async {
    await disconnect();
    return super.dispose();
  }
}
