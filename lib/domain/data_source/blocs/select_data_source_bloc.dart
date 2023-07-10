import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'select_data_source_bloc.freezed.dart';

@freezed
class SelectDataSourceEvent with _$SelectDataSourceEvent {
  const factory SelectDataSourceEvent.select(
    DataSource Function() initializer,
  ) = _Select;
}

enum SelectDataSourceError {
  unknown,
  isUnavailable,
  unsuccessfulEnableAttempt;

  R when<R>({
    required R Function() unknown,
    required R Function() isUnavailable,
    required R Function() unsuccessfulEnableAttempt,
  }) {
    switch (this) {
      case SelectDataSourceError.unknown:
        return unknown();
      case SelectDataSourceError.isUnavailable:
        return isUnavailable();
      case SelectDataSourceError.unsuccessfulEnableAttempt:
        return unsuccessfulEnableAttempt();
    }
  }
}

typedef SelectDataSourceState
    = AsyncData<Optional<DataSource>, SelectDataSourceError>;

class SelectDataSourceBloc
    extends Bloc<SelectDataSourceEvent, SelectDataSourceState> {
  SelectDataSourceBloc()
      : super(const SelectDataSourceState.initial(Optional.undefined())) {
    on<_Select>(_select);
  }

  Future<void> _select(
    _Select event,
    Emitter<SelectDataSourceState> emit,
  ) async {
    final selectedDataSource = event.initializer();
    emit(AsyncData.loading(Optional.presented(selectedDataSource)));

    try {
      if (!(await selectedDataSource.isAvailable)) {
        emit(state.inFailure(SelectDataSourceError.isUnavailable));
        await selectedDataSource.disconnectAndDispose();
        return;
      }

      if (!(await selectedDataSource.isEnabled)) {
        final result = await selectedDataSource.enable();
        final enabled = result.when(
          error: (e) {
            final error = e.when(
              unknown: () => SelectDataSourceError.unknown,
              isAlreadyEnabled: () {
                onError(EnableError.isAlreadyEnabled, StackTrace.current);
              },
              isUnavailable: () => SelectDataSourceError.isUnavailable,
              unsuccessfulEnableAttempt: () =>
                  SelectDataSourceError.unsuccessfulEnableAttempt,
            );
            if (error == null) return true;
            emit(state.inFailure(error));
            return false;
          },
          value: (_) => true,
        );
        if (!enabled) {
          await selectedDataSource.disconnectAndDispose();
          return;
        }
      }

      emit(state.inSuccess());
    } catch (e) {
      emit(state.inFailure());
      await selectedDataSource.disconnectAndDispose();

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
