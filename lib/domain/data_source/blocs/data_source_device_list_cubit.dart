import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef DataSourceDeviceListState = AsyncData<Set<DataSourceDevice>, Object>;

class DataSourceDeviceListCubit extends Cubit<DataSourceDeviceListState>
    with ConsumerBlocMixin {
  DataSourceDeviceListCubit({required this.dataSource})
      : super(const AsyncData.initial({}));

  @protected
  final DataSource dataSource;

  void init() {
    runZonedGuarded(
      () {
        dataSource.getDevicesStream().then((result) {
          result.when(
            error: (e) => emit(state.inFailure(e)),
            value: (stream) {
              emit(state.inSuccess());
              subscribe<List<DataSourceDevice>>(
                stream,
                (value) => emit(
                  AsyncData.success({...value}),
                ),
              );
            },
          );
        });
      },
      (error, stack) {
        emit(state.inFailure());

        addError(error, stack);
      },
    );
  }

  @override
  Future<void> close() async {
    await dataSource.cancelDeviceDiscovering();
    return super.close();
  }
}
