import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

mixin DefaultDataSourceObserverMixin on DataSource {
  final observers = <Observer>{};

  @override
  void addObserver(Observer observer) => observers.add(observer);

  @override
  void removeObserver(Observer observer) => observers.remove(observer);

  @override
  void observe(
    List<int>? package,
    DataSourceIncomingPackage? parsed,
    DataSourceRequestDirection direction,
  ) {
    for (final observer in observers) {
      observer(package, parsed, direction);
    }
  }

  void observeIncoming(List<int> package) {
    for (final observer in observers) {
      observer(package, null, DataSourceRequestDirection.incoming);
    }
  }

  void observeOutgoing(List<int> package) {
    for (final observer in observers) {
      observer(package, null, DataSourceRequestDirection.outgoing);
    }
  }

  void observeAll(
    List<List<int>> packages,
    DataSourceRequestDirection direction,
  ) {
    for (final package in packages) {
      observe(package, null, direction);
    }
  }

  @override
  Future<void> dispose() {
    observers.clear();
    return super.dispose();
  }
}
