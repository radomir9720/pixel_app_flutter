import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
class RequestsExchangeLogsFilterState {
  const RequestsExchangeLogsFilterState({
    this.parameterId = const [],
    this.requestType = const [],
    this.direction = const [],
  });

  final List<int> parameterId;

  final List<int> requestType;

  final List<int> direction;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestsExchangeLogsFilterState &&
        listEquals(other.parameterId, parameterId) &&
        listEquals(other.requestType, requestType) &&
        listEquals(other.direction, direction);
  }

  @override
  int get hashCode =>
      parameterId.hashCode ^ requestType.hashCode ^ direction.hashCode;

  RequestsExchangeLogsFilterState copyWith({
    List<int>? parameterId,
    List<int>? requestType,
    List<int>? direction,
  }) {
    return RequestsExchangeLogsFilterState(
      parameterId: parameterId ?? this.parameterId,
      requestType: requestType ?? this.requestType,
      direction: direction ?? this.direction,
    );
  }
}

class RequestsExchangeLogsFilterCubit
    extends Cubit<RequestsExchangeLogsFilterState> {
  RequestsExchangeLogsFilterCubit()
      : super(const RequestsExchangeLogsFilterState());

  void update(RequestsExchangeLogsFilterState newState) {
    emit(newState);
  }
}
