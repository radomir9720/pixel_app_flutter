import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'data_source_connect_bloc.freezed.dart';

@freezed
class DataSourceConnectEvent with _$DataSourceConnectEvent {
  const factory DataSourceConnectEvent.connect(
    DataSourceWithAddress dataSourceWithAddress,
  ) = _Connect;

  const factory DataSourceConnectEvent.tryConnectWithStorageData() =
      _TryConnectWithStorageData;
}

typedef DataSourceConnectState
    = AsyncData<Optional<DataSourceWithAddress>, Object>;

class DataSourceConnectBloc
    extends Bloc<DataSourceConnectEvent, DataSourceConnectState> {
  DataSourceConnectBloc({
    required this.dataSourceStorage,
    required this.availableDataSources,
  }) : super(const AsyncData.initial(Optional.undefined())) {
    on<_Connect>(_connect);
    on<_TryConnectWithStorageData>(_tryConnectWithStorageData);
  }

  @protected
  final DataSourceStorage dataSourceStorage;

  @protected
  final Map<String, DataSource Function()> availableDataSources;

  Future<void> _tryConnectWithStorageData(
    _TryConnectWithStorageData event,
    Emitter<DataSourceConnectState> emit,
  ) async {
    emit(state.inLoading());

    DataSource? dataSource;

    try {
      final values = dataSourceStorage.read();

      emit(
        await values.when(
          error: state.inFailure,
          value: (value) async {
            if (value.length != 2) return state.inFailure();

            final key = value.first;
            final address = value.last;

            final entry = availableDataSources.entries
                .firstWhere((element) => element.key == key);

            dataSource = entry.value();
            final result = await dataSource!.connect(address);

            return result.when(
              error: (e) async {
                await dataSource?.disconnectAndDispose();
                return state.inFailure(e);
              },
              value: (_) {
                final dataSourceWithAddress = Optional.presented(
                  DataSourceWithAddress(
                    dataSource: dataSource!,
                    address: address,
                  ),
                );

                return AsyncData.success(dataSourceWithAddress);
              },
            );
          },
        ),
      );
    } catch (e) {
      await dataSource?.disconnectAndDispose();
      emit(state.inFailure());
      rethrow;
    }
  }

  Future<void> _connect(
    _Connect event,
    Emitter<DataSourceConnectState> emit,
  ) async {
    emit(state.inLoading());

    final dswa = event.dataSourceWithAddress;
    try {
      final result = await dswa.dataSource.connect(dswa.address);

      emit(
        await result.when(
          error: (e) async {
            await dswa.dataSource.disconnectAndDispose();
            return state.inFailure();
          },
          value: (_) async {
            return AsyncData.success(
              Optional.presented(event.dataSourceWithAddress),
            );
          },
        ),
      );
    } catch (e) {
      await dswa.dataSource.disconnectAndDispose();
      emit(state.inFailure());
      rethrow;
    }
  }
}

extension on DataSource {
  Future<void> disconnectAndDispose() async {
    await disconnect();
    await dispose();
  }
}
