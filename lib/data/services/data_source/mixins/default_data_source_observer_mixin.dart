import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

mixin DefaultDataSourceObserverMixin on DataSource {
  final observers = <Observer>{};

  @override
  void addObserver(Observer observer) => observers.add(observer);

  @override
  void removeObserver(Observer observer) => observers.remove(observer);

  @override
  void observe(
    Observerable<dynamic> observable,
  ) {
    for (final observer in observers) {
      observer(observable);
    }
  }

  void observeIncoming(DataSourceIncomingPackage package) {
    for (final observer in observers) {
      observer(ParsedIncomingPackageObservable(package));
    }
  }

  void observeOutgoing(DataSourceOutgoingPackage package) {
    for (final observer in observers) {
      observer(OutgoingPackageObservable(package));
    }
  }

  @override
  Future<void> dispose() {
    observers.clear();
    return super.dispose();
  }
}
