import 'package:pixel_app_flutter/domain/data_source/services/data_source_service.dart';

mixin DefaultDataSourceObserverMixin on DataSource {
  final observers = <Observer>{};

  @override
  void addObserver(Observer observer) => observers.add(observer);

  @override
  void removeObserver(Observer observer) => observers.remove(observer);

  @override
  void observe(List<int> package) {
    for (final observer in observers) {
      observer(package);
    }
  }

  @override
  Future<void> dispose() {
    observers.clear();
    return super.dispose();
  }
}
