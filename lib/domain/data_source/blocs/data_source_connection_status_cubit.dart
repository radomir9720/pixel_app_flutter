import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

enum DataSourceConnectionStatus {
  lost,
  connected,
  disconnected,
  notEstablished;

  static DataSourceConnectionStatus fromDataSource(
    Optional<DataSourceWithAddress> dswa,
  ) {
    return dswa.isPresent
        ? DataSourceConnectionStatus.connected
        : DataSourceConnectionStatus.disconnected;
  }

  T maybeWhen<T>({
    required T Function() orElse,
    T Function()? lost,
    T Function()? connected,
    T Function()? disconnected,
    T Function()? notEstablished,
  }) {
    switch (this) {
      case DataSourceConnectionStatus.lost:
        return lost?.call() ?? orElse();
      case DataSourceConnectionStatus.connected:
        return connected?.call() ?? orElse();
      case DataSourceConnectionStatus.disconnected:
        return disconnected?.call() ?? orElse();
      case DataSourceConnectionStatus.notEstablished:
        return notEstablished?.call() ?? orElse();
    }
  }
}

class DataSourceConnectionStatusCubit extends Cubit<DataSourceConnectionStatus>
    with ConsumerBlocMixin {
  DataSourceConnectionStatusCubit({
    required this.dataSource,
    required this.dataSourceStorage,
    int debounceDuratiomMillis = 3000,
  })  : debouncer = Debouncer(milliseconds: debounceDuratiomMillis),
        super(
          DataSourceConnectionStatus.fromDataSource(dataSourceStorage.data),
        ) {
    _registerLostConnection(status: DataSourceConnectionStatus.notEstablished);
    subscribe(
      dataSource.eventStream,
      (event) => _registerLostConnection(),
    );
  }

  void _registerLostConnection({
    DataSourceConnectionStatus status = DataSourceConnectionStatus.lost,
  }) {
    debouncer.run(() {
      emit(status);
      dataSourceStorage.put(const Optional.undefined());
    });
  }

  @protected
  final DataSourceStorage dataSourceStorage;

  @protected
  final DataSource dataSource;

  @protected
  final Debouncer debouncer;
}
