import 'dart:async';

import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

mixin PackageStreamControllerMixin on DataSource {
  @protected
  @visibleForTesting
  final controller = StreamController<DataSourceIncomingPackage>.broadcast();

  @override
  Future<void> dispose() {
    controller.close();
    return super.dispose();
  }
}
