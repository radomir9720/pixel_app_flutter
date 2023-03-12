import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

enum DataSourceConnectionStatus {
  lost,
  connected,
  disconnected,
  notEstablished,
  handshakeTimeout;

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
    T Function()? handshakeTimeout,
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
      case DataSourceConnectionStatus.handshakeTimeout:
        return handshakeTimeout?.call() ?? orElse();
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
    _registerDisconnectStatusWithDebounce(
      status: DataSourceConnectionStatus.notEstablished,
    );
    subscribe(
      dataSource.eventStream,
      (event) => _registerDisconnectStatusWithDebounce(),
    );
  }

  void _registerDisconnectStatusWithDebounce({
    DataSourceConnectionStatus status = DataSourceConnectionStatus.lost,
  }) =>
      debouncer.run(() => _registerDisconnectStatus(status));

  void _registerDisconnectStatus(DataSourceConnectionStatus status) {
    if (isClosed) return;
    emit(status);
    dataSourceStorage.put(const Optional.undefined());
    Future<void>.error(status);
  }

  void registerHandshakeTimeoutError() {
    _registerDisconnectStatus(DataSourceConnectionStatus.handshakeTimeout);
  }

  @protected
  final DataSourceStorage dataSourceStorage;

  @protected
  final DataSource dataSource;

  @protected
  final Debouncer debouncer;

  @override
  Future<void> close() {
    debouncer.dispose();
    return super.close();
  }
}
