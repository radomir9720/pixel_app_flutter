import 'dart:async';

import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

mixin DevicesPeriodicStreamMixin on DataSource {
  final _devicesStreamController =
      StreamController<List<DataSourceDevice>>.broadcast();

  static const kDefaultScanDevicesPeriod = Duration(seconds: 3);

  Timer? timer;

  Stream<List<DataSourceDevice>> getDevicePeriodicStream<T>({
    required Future<List<T>> Function() getDevices,
    required DataSourceDevice Function(T object) mapToDataSourceDevice,
    Duration scanDevicePeriod = kDefaultScanDevicesPeriod,
  }) {
    timer ??= Timer.periodic(
      const Duration(milliseconds: 200),
      (_) {
        if (!_devicesStreamController.hasListener) return;
        _addDevicesToStream(getDevices, mapToDataSourceDevice);
        timer?.cancel();
        timer = Timer.periodic(scanDevicePeriod, (timer) {
          _addDevicesToStream(getDevices, mapToDataSourceDevice);
        });
      },
    );

    return _devicesStreamController.stream;
  }

  Future<void> _addDevicesToStream<T>(
    Future<List<T>> Function() getDevices,
    DataSourceDevice Function(T object) mapToDataSourceDevice,
  ) async {
    final devices = await getDevices();

    final dataSourceDevices = devices.map(mapToDataSourceDevice);
    _devicesStreamController.add([...dataSourceDevices]);
  }

  @override
  Future<Result<CancelDeviceDiscoveringError, void>>
      cancelDeviceDiscovering() async {
    timer?.cancel();
    timer = null;
    return const Result.value(null);
  }

  @override
  Future<void> dispose() {
    timer?.cancel();
    timer = null;
    _devicesStreamController.close();
    return super.dispose();
  }
}
