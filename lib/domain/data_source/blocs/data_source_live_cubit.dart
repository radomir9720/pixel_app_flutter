import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef Observer = void Function(DataSourceEvent event);

@immutable
class DataSourceLiveState {
  const DataSourceLiveState({
    required this.speed,
    required this.odometer,
    required this.sunCharging,
    required this.wireCharging,
    required this.battery,
    required this.leftDoorOpened,
    required this.rightDoorOpened,
    required this.frontTrunkOpened,
    required this.trunkOpened,
    required this.lightOn,
    required this.parameters,
  });

  final int speed;

  final int odometer;

  final int sunCharging;

  final bool wireCharging;

  final int battery;

  final bool leftDoorOpened;

  final bool rightDoorOpened;

  final bool frontTrunkOpened;

  final bool trunkOpened;

  final bool lightOn;

  final DeveloperToolsParameters parameters;

  @override
  int get hashCode => Object.hash(
        speed,
        odometer,
        sunCharging,
        wireCharging,
        battery,
        leftDoorOpened,
        rightDoorOpened,
        frontTrunkOpened,
        trunkOpened,
        lightOn,
        parameters,
      );

  @override
  bool operator ==(dynamic other) {
    return other is DataSourceLiveState &&
        other.speed == speed &&
        other.odometer == odometer &&
        other.sunCharging == sunCharging &&
        other.wireCharging == wireCharging &&
        other.battery == battery &&
        other.leftDoorOpened == leftDoorOpened &&
        other.rightDoorOpened == rightDoorOpened &&
        other.frontTrunkOpened == frontTrunkOpened &&
        other.trunkOpened == trunkOpened &&
        other.lightOn == lightOn &&
        other.parameters == parameters;
  }

  DataSourceLiveState copyWith({
    int? speed,
    int? odometer,
    int? sunCharging,
    bool? wireCharging,
    int? battery,
    bool? leftDoorOpened,
    bool? rightDoorOpened,
    bool? frontTrunkOpened,
    bool? trunkOpened,
    bool? lightOn,
    DeveloperToolsParameters? parameters,
  }) {
    return DataSourceLiveState(
      speed: speed ?? this.speed,
      odometer: odometer ?? this.odometer,
      sunCharging: sunCharging ?? this.sunCharging,
      wireCharging: wireCharging ?? this.wireCharging,
      battery: battery ?? this.battery,
      leftDoorOpened: leftDoorOpened ?? this.leftDoorOpened,
      rightDoorOpened: rightDoorOpened ?? this.rightDoorOpened,
      frontTrunkOpened: frontTrunkOpened ?? this.frontTrunkOpened,
      trunkOpened: trunkOpened ?? this.trunkOpened,
      lightOn: lightOn ?? this.lightOn,
      parameters: parameters ?? this.parameters,
    );
  }
}

class DataSourceLiveCubit extends Cubit<DataSourceLiveState>
    with ConsumerBlocMixin {
  DataSourceLiveCubit({
    required this.dataSource,
    required this.developerToolsParametersStorage,
  })  : observers = {},
        initDateTime = DateTime.now(),
        super(
          DataSourceLiveState(
            speed: 0,
            battery: 0,
            odometer: 0,
            sunCharging: 0,
            lightOn: false,
            trunkOpened: false,
            wireCharging: false,
            leftDoorOpened: false,
            rightDoorOpened: false,
            frontTrunkOpened: false,
            parameters: developerToolsParametersStorage.read().when(
                  error: (e) => developerToolsParametersStorage.defaultValue,
                  value: (v) => v,
                ),
          ),
        ) {
    subscribe<DeveloperToolsParameters>(
      developerToolsParametersStorage,
      _onDeveloperToolsParametersUpdated,
    );

    subscribe<DataSourceIncomingEvent>(dataSource.eventStream, (event) {
      _observe(event);
      event.maybeWhen(
        updateValue: (id) =>
            _onParameterValueUpdated(id, event.package.data.toInt),
        getParameterValue: (id) =>
            _onParameterValueUpdated(id, event.package.data.toInt),
        subscriptionResponse: (id) =>
            _onParameterValueUpdated(id, event.package.data.toInt),
        handshake: () {
          final id = event.package.parameterId;
          // Do not respond to handshake response from MainECU
          if (id == 0) return;
          final enableResponse =
              developerToolsParametersStorage.data.enableHandshakeResponse;
          if (!enableResponse) return;
          final timeout = developerToolsParametersStorage
              .data.handshakeResponseTimeoutInMillis;
          Future<void>.delayed(Duration(milliseconds: timeout)).then((value) {
            final event = DataSourceHandshakeOutgoingEvent.ping(handhsakeId);
            _observe(event);
            dataSource.sendEvent(event);
          });
        },
        orElse: () {},
      );
    });
  }

  Timer? timer;

  final DateTime initDateTime;

  late final List<DataSourceParameterId> subscribeToParameterIdList;

  final Set<Observer> observers;

  @protected
  final DataSource dataSource;

  @protected
  final DeveloperToolsParametersStorage developerToolsParametersStorage;

  int get handhsakeId {
    final diff = DateTime.now().difference(initDateTime).inMilliseconds;
    if (diff > 0xFFFFFFFF) {
      final str = diff.toRadixString(16);
      return int.parse(str.substring(str.length - 8), radix: 16);
    }
    return diff;
  }

  void _onDeveloperToolsParametersUpdated(DeveloperToolsParameters newParams) {
    if (newParams == state.parameters) return;
    final newRequestPeriod = newParams.requestsPeriodInMillis;
    final newSubscribeToParams = newParams.subscriptionParameterIds
        .map(DataSourceParameterId.fromInt)
        .toList();
    if (newParams.protocolVersion != state.parameters.protocolVersion) {
      newParams.protocolVersion.when(
        subscription: () {
          _cancelTimer();
          subscribeTo(newSubscribeToParams);
        },
        periodicRequests: () {
          unsubscribeFrom(subscribeToParameterIdList);
          _setNewTimer(newRequestPeriod, newSubscribeToParams);
        },
      );
    } else if (newParams.requestsPeriodInMillis !=
        state.parameters.requestsPeriodInMillis) {
      _setNewTimer(newRequestPeriod, subscribeToParameterIdList);
    } else if (!const DeepCollectionEquality.unordered().equals(
      newParams.subscriptionParameterIds,
      subscribeToParameterIdList,
    )) {
      state.parameters.protocolVersion.when(
        subscription: () {
          unsubscribeFrom(subscribeToParameterIdList);
          subscribeTo(newSubscribeToParams);
        },
        periodicRequests: () {
          _setNewTimer(newRequestPeriod, newSubscribeToParams);
        },
      );
    }

    emit(state.copyWith(parameters: newParams));
  }

  void _cancelTimer() {
    timer?.cancel();
    timer = null;
  }

  void _setNewTimer(int requestPeriod, List<DataSourceParameterId> ids) {
    _cancelTimer();
    timer = Timer.periodic(
      Duration(milliseconds: requestPeriod),
      (timer) {
        for (final id in ids) {
          getValue(id);
        }
      },
    );
    final newIdList = [...ids];
    subscribeToParameterIdList
      ..clear()
      ..addAll(newIdList);
  }

  void _onParameterValueUpdated(DataSourceParameterId id, int value) {
    emit(
      id.when(
        speed: () => state.copyWith(speed: value),
        light: () => state.copyWith(lightOn: value == 1),
        voltage: () => state.copyWith(battery: value),
        current: () => state.copyWith(sunCharging: value),
        custom: (id) => state,
      ),
    );
  }

  void initHandshake() {
    final event = DataSourceHandshakeOutgoingEvent.initial(handhsakeId);
    _observe(event);
    dataSource.sendEvent(event);
  }

  void initParametersSubscription() {
    subscribeToParameterIdList = state.parameters.subscriptionParameterIds
        .map(DataSourceParameterId.fromInt)
        .toList();

    state.parameters.protocolVersion.when(
      subscription: () {
        subscribeTo(subscribeToParameterIdList);
      },
      periodicRequests: () {
        _setNewTimer(
          state.parameters.requestsPeriodInMillis,
          subscribeToParameterIdList,
        );
      },
    );
  }

  void subscribeTo(List<DataSourceParameterId> ids) {
    for (final id in ids) {
      final event = DataSourceSubscribeOutgoingEvent(id: id);
      _observe(event);
      dataSource.sendEvent(event);
    }
    final newIdList = [...ids];
    subscribeToParameterIdList
      ..clear()
      ..addAll(newIdList);
  }

  void unsubscribeFrom(List<DataSourceParameterId> ids) {
    for (final id in ids) {
      final event = DataSourceUnsubscribeOutgoingEvent(id: id);
      _observe(event);
      dataSource.sendEvent(event);
    }
  }

  void getValue(DataSourceParameterId id) {
    final event = DataSourceGetParameterValueOutgoingEvent(id: id);
    _observe(event);
    dataSource.sendEvent(event);
  }

  void _observe(DataSourceEvent event) {
    for (final observer in observers) {
      observer(event);
    }
  }

  void addObserver(Observer observer) {
    observers.add(observer);
  }

  void removeObserver(Observer observer) {
    observers.remove(observer);
  }

  @override
  Future<void> close() {
    observers.clear();
    _cancelTimer();
    dataSource.disconnect();
    return super.close();
  }
}
