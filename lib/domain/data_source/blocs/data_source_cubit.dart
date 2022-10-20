import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'data_source_cubit.freezed.dart';

@freezed
class DataSourceState with _$DataSourceState {
  const DataSourceState._();

  const factory DataSourceState.initial(Optional<DataSourceWithAddress> ds) =
      _Initial;
  const factory DataSourceState.loaded(Optional<DataSourceWithAddress> ds) =
      _Loaded;

  bool get isInitial => maybeWhen(orElse: () => false, initial: (_) => true);
}

class DataSourceCubit extends Cubit<DataSourceState> with ConsumerBlocMixin {
  DataSourceCubit({required this.dataSourceStorage})
      : super(const DataSourceState.initial(Optional.undefined())) {
    subscribe<Optional<DataSourceWithAddress>>(
      dataSourceStorage,
      (v) => emit(DataSourceState.loaded(v)),
    );
  }

  @protected
  final DataSourceStorage dataSourceStorage;
}
