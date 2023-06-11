import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/outgoing_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

enum DataSourceConnectionStatus {
  lost,
  connected,
  disconnected,
  notEstablished,
  waitingForHandshakeResponse,
  handshakeTimeout;

  bool get isWaitingForHandshakeResponse =>
      this == DataSourceConnectionStatus.waitingForHandshakeResponse;

  T maybeWhen<T>({
    required T Function() orElse,
    T Function()? lost,
    T Function()? connected,
    T Function()? disconnected,
    T Function()? notEstablished,
    T Function()? handshakeTimeout,
    T Function()? waitingForHandshakeResponse,
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
      case DataSourceConnectionStatus.waitingForHandshakeResponse:
        return waitingForHandshakeResponse?.call() ?? orElse();
    }
  }
}

class DataSourceConnectionStatusCubit extends Cubit<DataSourceConnectionStatus>
    with
        ConsumerBlocMixin,
        BlocLoggerMixin<DataSourcePackage, DataSourceConnectionStatus> {
  DataSourceConnectionStatusCubit({
    required this.dataSource,
    required this.dataSourceStorage,
    required this.developerToolsParametersStorage,
    this.handshakeTimeout = const Duration(milliseconds: 2000),
    List<BlocLoggerCallback<DataSourcePackage>> loggers = const [],
    int debounceDurationMillis = 3000,
  })  : debouncer = Debouncer(milliseconds: debounceDurationMillis),
        initDateTime = DateTime.now(),
        super(DataSourceConnectionStatus.waitingForHandshakeResponse) {
    addLoggers(loggers);

    _registerDisconnectStatusWithDebounce(
      status: DataSourceConnectionStatus.notEstablished,
    );

    subscribe<DataSourceIncomingPackage>(
      dataSource.packageStream,
      (event) {
        log(event);

        event
          ..voidOnModel<EmptyHandshakeBody,
              HandshakeInitialIncomingDataSourcePackage>((_) {
            emit(DataSourceConnectionStatus.connected);
          })
          ..voidOnModel<HandshakeID, HandshakePingIncomingDataSourcePackage>(
              (model) {
            emit(DataSourceConnectionStatus.connected);
            final enableResponse =
                developerToolsParametersStorage.data.enableHandshakeResponse;
            if (!enableResponse) return;
            final timeout = developerToolsParametersStorage
                .data.handshakeResponseTimeoutInMillis;
            Future<void>.delayed(Duration(milliseconds: timeout)).then((value) {
              final package = OutgoingPingHandshakePackage(
                handshakeId: HandshakeID(handshakeId),
              );
              log(package);
              dataSource.sendPackage(package);
            });
          });

        _registerDisconnectStatusWithDebounce();
      },
    );

    Future<void>.delayed(handshakeTimeout).then(
      (value) {
        if (isClosed) return;
        if (state.isWaitingForHandshakeResponse) {
          _registerDisconnectStatus(
            DataSourceConnectionStatus.handshakeTimeout,
          );
        }
      },
    );
  }

  int get handshakeId {
    final diff = DateTime.now().difference(initDateTime).inMilliseconds;
    return diff;
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

  void initHandshake() {
    final package =
        OutgoingInitialHandshakePackage(handshakeId: HandshakeID(handshakeId));
    log(package);
    dataSource.sendPackage(package);
  }

  @visibleForTesting
  final DateTime initDateTime;

  @protected
  final DataSourceStorage dataSourceStorage;

  @protected
  final DataSource dataSource;

  @visibleForTesting
  final Debouncer debouncer;

  @protected
  final Duration handshakeTimeout;

  @protected
  final DeveloperToolsParametersStorage developerToolsParametersStorage;

  @override
  Future<void> close() {
    debouncer.dispose();
    return super.close();
  }
}
