import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/developer_tools/developer_tools.dart';

class ExchangeConsoleLogsCubit
    extends Cubit<List<RawRequestsExchangeLogsState>> {
  ExchangeConsoleLogsCubit({
    required this.filterCubit,
    this.maxItems = 150,
  }) : super([]);

  @visibleForTesting
  final int maxItems;

  void addRaw(List<int> data, DataSourceRequestDirection direction) {
    // Just in case
    if (isClosed) return;

    final log = RawRequestsExchangeLogsState(data, DateTime.now(), direction);

    final satisfies = log.filter(
      parameterId: filterCubit.state.parameterId,
      requestType: filterCubit.state.requestType,
      direction: filterCubit.state.direction,
      acceptEmptyParameterId: false,
      acceptUnparsed: false,
    );

    if (!satisfies) return;

    emit([
      ...state.reversed.take(maxItems - 1).toList().reversed,
      log,
    ]);
  }

  void addParsed(DataSourcePackage data, DataSourceRequestDirection direction) {
    // Just in case
    if (isClosed) return;

    final log = ProcessedRequestsExchangeLogsState(
      data,
      DateTime.now(),
      direction,
    );

    final satisfies = log.filter(
      parameterId: filterCubit.state.parameterId,
      requestType: filterCubit.state.requestType,
      direction: filterCubit.state.direction,
      acceptEmptyParameterId: false,
    );

    if (!satisfies) return;

    emit([
      ...state.reversed.take(maxItems - 1).toList().reversed,
      RawRequestsExchangeLogsState(data, log.dateTime, direction),
    ]);
  }

  void clear() => emit([]);

  @protected
  final RequestsExchangeLogsFilterCubit filterCubit;
}
