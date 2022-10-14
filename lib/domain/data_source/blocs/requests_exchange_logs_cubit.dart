import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

@immutable
class RequestsExchangeLogsEvent {
  const RequestsExchangeLogsEvent(
    this.event,
    this.dateTime,
  );

  final DataSourceEvent event;

  final DateTime dateTime;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RequestsExchangeLogsEvent &&
        other.event == event &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode => event.hashCode ^ dateTime.hashCode;
}

class RequestsExchangeLogsCubit extends Cubit<List<RequestsExchangeLogsEvent>> {
  RequestsExchangeLogsCubit() : super([]);

  void add(DataSourceEvent event) {
    emit([
      ...state.reversed.take(150).toList().reversed,
      RequestsExchangeLogsEvent(event, DateTime.now())
    ]);
  }
}
