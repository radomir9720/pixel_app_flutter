import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'select_data_source_bloc.freezed.dart';

@freezed
class SelectDataSourceEvent with _$SelectDataSourceEvent {
  const factory SelectDataSourceEvent.select(DataSource selectedDataSource) =
      _Select;
}

@immutable
class DataSourcePack {
  const DataSourcePack(this.all, this.selected);

  final List<DataSource> all;

  final Optional<DataSource> selected;

  DataSourcePack copyWith({
    List<DataSource>? all,
    Optional<DataSource>? selected,
  }) {
    return DataSourcePack(
      all ?? this.all,
      selected ?? this.selected,
    );
  }
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
    = AsyncData<DataSourcePack, SelectDataSourceError>;

class SelectDataSourceBloc
    extends Bloc<SelectDataSourceEvent, SelectDataSourceState> {
  SelectDataSourceBloc({required this.dataSources})
      : super(
          SelectDataSourceState.initial(
            DataSourcePack(dataSources, const Optional.undefined()),
          ),
        ) {
    on<_Select>(_select);
  }

  @protected
  final List<DataSource> dataSources;

  Future<void> _select(
    _Select event,
    Emitter<SelectDataSourceState> emit,
  ) async {
    final selectedDataSource = event.selectedDataSource;
    emit(
      AsyncData.loading(
        state.payload.copyWith(
          selected: Optional.presented(selectedDataSource),
        ),
      ),
    );

    try {
      if (!(await selectedDataSource.isAvailable)) {
        emit(state.inFailure(SelectDataSourceError.isUnavailable));
        return;
      }

      if (!(await selectedDataSource.isEnabled)) {
        final result = await selectedDataSource.enable();
        final enabled = result.when(
          error: (e) {
            final error = e.when(
              unknown: () => SelectDataSourceError.unknown,
              isAlreadyEnabled: () {
                Future<void>.error(EnableError.isAlreadyEnabled);
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
        if (!enabled) return;
      }

      emit(state.inSuccess());
    } catch (e) {
      emit(state.inFailure());

      rethrow;
    }
  }
}
