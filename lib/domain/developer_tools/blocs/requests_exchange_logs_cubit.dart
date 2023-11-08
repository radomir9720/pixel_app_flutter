import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

@immutable
abstract class RequestsExchangeLogsStateBase<T> with EquatableMixin {
  const RequestsExchangeLogsStateBase(
    this.data,
    this.dateTime,
    this.direction,
  );

  final T data;

  final DataSourceRequestDirection direction;

  final DateTime dateTime;

  bool filter({
    required List<int> parameterId,
    required List<int> requestType,
    required List<int> direction,
  });

  @override
  List<Object?> get props => [data, dateTime, direction];
}

@immutable
class ProcessedRequestsExchangeLogsState
    extends RequestsExchangeLogsStateBase<DataSourcePackage> {
  const ProcessedRequestsExchangeLogsState(
    super.data,
    super.dateTime,
    super.direction,
  );

  @override
  bool filter({
    required List<int> parameterId,
    required List<int> requestType,
    required List<int> direction,
    bool acceptEmptyParameterId = true,
    bool acceptEmptyrequestType = true,
    bool acceptEmptydirection = true,
  }) {
    return ((acceptEmptyParameterId && parameterId.isEmpty) ||
            parameterId.contains(data.parameterId.value)) &&
        ((acceptEmptyrequestType && requestType.isEmpty) ||
            requestType.contains(data.requestType.value)) &&
        ((acceptEmptydirection && direction.isEmpty) ||
            direction.contains(this.direction.value));
  }
}

class RawRequestsExchangeLogsState
    extends RequestsExchangeLogsStateBase<List<int>> {
  const RawRequestsExchangeLogsState(
    super.data,
    super.dateTime,
    super.direction,
  );

  @override
  bool filter({
    required List<int> parameterId,
    required List<int> requestType,
    required List<int> direction,
    bool acceptEmptyParameterId = true,
    bool acceptEmptyrequestType = true,
    bool acceptEmptydirection = true,
    bool acceptUnparsed = true,
  }) {
    final package = DataSourceIncomingPackage.instanceOrNUll(data);
    if (!acceptUnparsed && package == null) return false;

    return (package == null ||
            (acceptEmptyParameterId && parameterId.isEmpty) ||
            parameterId.contains(package.parameterId.value)) &&
        ((acceptEmptyrequestType && requestType.isEmpty) ||
            package == null ||
            requestType.contains(package.requestType.value)) &&
        ((acceptEmptydirection && direction.isEmpty) ||
            direction.contains(this.direction.value));
  }
}

abstract class RequestsExchangeLogsCubitBase<S,
    T extends RequestsExchangeLogsStateBase<S>> extends Cubit<List<T>> {
  RequestsExchangeLogsCubitBase({this.maxItems = 500}) : super([]);

  @visibleForTesting
  final int maxItems;

  void add(S data, DataSourceRequestDirection direction);
}

class ProcessedRequestsExchangeLogsCubit extends RequestsExchangeLogsCubitBase<
    DataSourcePackage, ProcessedRequestsExchangeLogsState> {
  ProcessedRequestsExchangeLogsCubit({super.maxItems});

  @override
  void add(DataSourcePackage data, DataSourceRequestDirection direction) {
    // Just in case
    if (isClosed) return;

    emit([
      ...state.reversed.take(maxItems - 1).toList().reversed,
      ProcessedRequestsExchangeLogsState(data, DateTime.now(), direction),
    ]);
  }
}

class RawRequestsExchangeLogsCubit extends RequestsExchangeLogsCubitBase<
    List<int>, RawRequestsExchangeLogsState> {
  RawRequestsExchangeLogsCubit({super.maxItems});

  @override
  void add(List<int> data, DataSourceRequestDirection direction) {
    // Just in case
    if (isClosed) return;

    emit([
      ...state.reversed.take(maxItems - 1).toList().reversed,
      RawRequestsExchangeLogsState(data, DateTime.now(), direction),
    ]);
  }
}
