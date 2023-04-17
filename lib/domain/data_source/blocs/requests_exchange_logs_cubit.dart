import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

@immutable
abstract class RequestsExchangeLogsStateBase<T> {
  const RequestsExchangeLogsStateBase(
    this.data,
    this.dateTime,
  );

  final T data;

  final DateTime dateTime;

  bool filter({
    required List<int> parameterId,
    required List<int> requestType,
    required List<int> direction,
  });
}

@immutable
class ProcessedRequestsExchangeLogsState
    extends RequestsExchangeLogsStateBase<DataSourcePackage> {
  const ProcessedRequestsExchangeLogsState(super.data, super.dateTime);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProcessedRequestsExchangeLogsState &&
        other.data == data &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode => data.hashCode ^ dateTime.hashCode;

  @override
  bool filter({
    required List<int> parameterId,
    required List<int> requestType,
    required List<int> direction,
  }) {
    return (parameterId.isEmpty ||
            parameterId.contains(data.parameterId.value)) &&
        (requestType.isEmpty || requestType.contains(data.requestType.value)) &&
        (direction.isEmpty || direction.contains(data.directionFlag.value));
  }
}

class RawRequestsExchangeLogsState
    extends RequestsExchangeLogsStateBase<List<int>> {
  const RawRequestsExchangeLogsState(super.data, super.dateTime);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RawRequestsExchangeLogsState &&
        listEquals(other.data, data) &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode => data.hashCode ^ dateTime.hashCode;

  @override
  bool filter({
    required List<int> parameterId,
    required List<int> requestType,
    required List<int> direction,
  }) {
    final package = DataSourceIncomingPackage.instanceOrNUll(data);
    if (package == null) return true;
    return (parameterId.isEmpty ||
            parameterId.contains(package.parameterId.value)) &&
        (requestType.isEmpty ||
            requestType.contains(package.requestType.value)) &&
        (direction.isEmpty || direction.contains(package.directionFlag.value));
  }
}

abstract class RequestsExchangeLogsCubitBase<S,
    T extends RequestsExchangeLogsStateBase<S>> extends Cubit<List<T>> {
  RequestsExchangeLogsCubitBase({this.maxItems = 150}) : super([]);

  @visibleForTesting
  final int maxItems;

  void add(S data);
}

class ProcessedRequestsExchangeLogsCubit extends RequestsExchangeLogsCubitBase<
    DataSourcePackage, ProcessedRequestsExchangeLogsState> {
  ProcessedRequestsExchangeLogsCubit({super.maxItems});

  @override
  void add(DataSourcePackage data) {
    // Just in case
    if (isClosed) return;

    emit([
      ...state.reversed.take(maxItems - 1).toList().reversed,
      ProcessedRequestsExchangeLogsState(data, DateTime.now())
    ]);
  }
}

class RawRequestsExchangeLogsCubit extends RequestsExchangeLogsCubitBase<
    List<int>, RawRequestsExchangeLogsState> {
  RawRequestsExchangeLogsCubit({super.maxItems});

  @override
  void add(List<int> data) {
    // Just in case
    if (isClosed) return;

    emit([
      ...state.reversed.take(maxItems - 1).toList().reversed,
      RawRequestsExchangeLogsState(data, DateTime.now())
    ]);
  }
}
