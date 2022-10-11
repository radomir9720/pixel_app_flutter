import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef DataSourceDeviceListState = AsyncData<List<DataSourceDevice>, Object>;

class DataSourceDeviceListCubit extends Cubit<DataSourceDeviceListState>
    with ConsumerBlocMixin {
  DataSourceDeviceListCubit({required this.dataSource})
      : super(const AsyncData.initial([])) {
    try {
      dataSource.getDeviceStream().then((result) {
        result.when(
          error: (e) => emit(state.inFailure(e)),
          value: (stream) {
            subscribe<DataSourceDevice>(
              stream,
              (value) => emit(
                AsyncData.success([
                  ...state.payload,
                  value,
                ]),
              ),
            );
          },
        );
      });
    } catch (e) {
      emit(state.inFailure());

      rethrow;
    }
  }

  @protected
  final DataSource dataSource;

  @override
  Future<void> close() async {
    await dataSource.cancelDeviceDiscovering();
    return super.close();
  }
}
