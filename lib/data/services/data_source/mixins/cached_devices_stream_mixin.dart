import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

mixin CachedDevicesStreamMixin on DataSource {
  @protected
  @visibleForTesting
  final dataSourceDevicesCache = <DataSourceDevice>{};

  @protected
  @visibleForTesting
  final cachedDataSourceDevicesStreamController =
      StreamController<List<DataSourceDevice>>.broadcast();

  StreamSubscription<void>? _subscription;

  Stream<List<DataSourceDevice>> getCachedDevicesStream<T>({
    required Stream<T> devicesStream,
    required DataSourceDevice Function(T object) mapToDataSourceDevice,
  }) {
    _subscription?.cancel();
    _subscription = devicesStream.listen((event) {
      final dataSourceDevice = mapToDataSourceDevice(event);
      dataSourceDevicesCache.add(dataSourceDevice);
      cachedDataSourceDevicesStreamController.add([...dataSourceDevicesCache]);
    });

    return cachedDataSourceDevicesStreamController.stream;
  }

  @override
  Future<void> dispose() {
    _subscription?.cancel();
    cachedDataSourceDevicesStreamController.close();
    return super.dispose();
  }
}
