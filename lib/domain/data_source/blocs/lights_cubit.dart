import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/outgoing_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class LightsStateError {
  const LightsStateError();

  const factory LightsStateError.differs({
    required bool first,
    required bool second,
  }) = _StatesDiffersEnablingError;

  const factory LightsStateError.timeout() = _TimeoutEnablingError;
  const factory LightsStateError.mainECUError() = _MainECUEnablingError;

  bool get isTimeout => this is _TimeoutEnablingError;
  bool get differs => this is _StatesDiffersEnablingError;
  bool get mainECUError => this is _MainECUEnablingError;

  R when<R>({
    required R Function() differs,
    required R Function() timeout,
    required R Function() mainECUError,
  });
}

class _StatesDiffersEnablingError extends LightsStateError {
  const _StatesDiffersEnablingError({
    required this.first,
    required this.second,
  });

  final bool first;
  final bool second;

  @override
  R when<R>({
    required R Function() differs,
    required R Function() timeout,
    required R Function() mainECUError,
  }) {
    return differs();
  }
}

class _TimeoutEnablingError extends LightsStateError {
  const _TimeoutEnablingError();

  @override
  R when<R>({
    required R Function() differs,
    required R Function() timeout,
    required R Function() mainECUError,
  }) {
    return timeout();
  }
}

class _MainECUEnablingError extends LightsStateError {
  const _MainECUEnablingError();

  @override
  R when<R>({
    required R Function() differs,
    required R Function() timeout,
    required R Function() mainECUError,
  }) {
    return mainECUError();
  }
}

typedef LightState<T> = AsyncData<T, LightsStateError>;

@sealed
@immutable
class TwoBoolsState {
  const TwoBoolsState({
    required this.first,
    required this.second,
    required this.waitingForSwitch,
  });

  const TwoBoolsState.on()
      : first = true,
        second = true,
        waitingForSwitch = null;

  const TwoBoolsState.off()
      : first = false,
        second = false,
        waitingForSwitch = null;

  final bool first;
  final bool second;
  final bool? waitingForSwitch;

  bool get isOn => first || second;
  bool get isOff => !first && !second;
  bool get differs => first != second;
  bool get bothOn => first && second;

  int get oppositeValue => (!(differs || isOn)).toInt;
  bool get oppositeBool => !differs && !isOn;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TwoBoolsState &&
        other.first == first &&
        other.second == second &&
        other.waitingForSwitch == waitingForSwitch;
  }

  @override
  int get hashCode =>
      first.hashCode ^ second.hashCode ^ waitingForSwitch.hashCode;

  TwoBoolsState copyWith({
    bool? first,
    bool? second,
    bool? waitingForSwitch,
    bool setWaitingForSwitchToNull = false,
  }) {
    return TwoBoolsState(
      first: first ?? this.first,
      second: second ?? this.second,
      waitingForSwitch: setWaitingForSwitchToNull
          ? null
          : waitingForSwitch ?? this.waitingForSwitch,
    );
  }

  @override
  String toString() => 'TwoBoolsState(first: $first, '
      'second: $second, '
      'waitingForSwitch: $waitingForSwitch)';
}

@sealed
@immutable
class LightsState with EquatableMixin {
  const LightsState({
    required this.leftTurnSignal,
    required this.rightTurnSignal,
    required this.hazardBeam,
    required this.sideBeam,
    required this.lowBeam,
    required this.highBeam,
  });

  const LightsState.initial({
    this.leftTurnSignal = const AsyncData.loading(TwoBoolsState.off()),
    this.rightTurnSignal = const AsyncData.loading(TwoBoolsState.off()),
    this.hazardBeam = const AsyncData.loading(TwoBoolsState.off()),
    this.sideBeam = const AsyncData.loading(TwoBoolsState.off()),
    this.lowBeam = const AsyncData.loading(false),
    this.highBeam = const AsyncData.loading(false),
  });

  final LightState<TwoBoolsState> leftTurnSignal;
  final LightState<TwoBoolsState> rightTurnSignal;
  final LightState<TwoBoolsState> hazardBeam;
  final LightState<TwoBoolsState> sideBeam;
  final LightState<bool> lowBeam;
  final LightState<bool> highBeam;

  bool get hasFailureState => [
        leftTurnSignal,
        rightTurnSignal,
        hazardBeam,
        sideBeam,
        lowBeam,
        highBeam
      ].any((element) => element.isFailure);

  List<R> whenFailure<R>(
    LightsState prevState, {
    required R Function(LightsStateError error) leftTurnSignal,
    required R Function(LightsStateError error) rightTurnSignal,
    required R Function(LightsStateError error) hazardBeam,
    required R Function(LightsStateError error) sideBeam,
    required R Function(LightsStateError error) lowBeam,
    required R Function(LightsStateError error) highBeam,
  }) {
    final leftTurnSignalError = this.leftTurnSignal.error;
    final rightTurnSignalError = this.rightTurnSignal.error;
    final hazardBeamError = this.hazardBeam.error;
    final lowBeamError = this.lowBeam.error;
    final highBeamError = this.highBeam.error;
    final sideBeamError = this.sideBeam.error;

    final errors = [
      _filterError(
        leftTurnSignalError,
        prevState.leftTurnSignal.error,
        leftTurnSignal,
      ),
      _filterError(
        rightTurnSignalError,
        prevState.rightTurnSignal.error,
        rightTurnSignal,
      ),
      _filterError(
        hazardBeamError,
        prevState.hazardBeam.error,
        hazardBeam,
      ),
      _filterError(
        sideBeamError,
        prevState.sideBeam.error,
        sideBeam,
      ),
      _filterError(
        lowBeamError,
        prevState.lowBeam.error,
        lowBeam,
      ),
      _filterError(
        highBeamError,
        prevState.highBeam.error,
        highBeam,
      ),
    ].whereType<R>().toList();

    return errors;
  }

  R? _filterError<R>(
    LightsStateError? current,
    LightsStateError? prev,
    R Function(LightsStateError) callback,
  ) {
    if (current == null) return null;
    if (current.isTimeout && prev != null && !prev.isTimeout) return null;
    if (current == prev) return null;
    return callback(current);
  }

  @override
  List<Object?> get props => [
        leftTurnSignal,
        rightTurnSignal,
        hazardBeam,
        sideBeam,
        lowBeam,
        highBeam,
      ];

  LightsState copyWith({
    LightState<TwoBoolsState>? leftTurnSignal,
    LightState<TwoBoolsState>? rightTurnSignal,
    LightState<TwoBoolsState>? hazardBeam,
    LightState<TwoBoolsState>? sideBeam,
    LightState<bool>? lowBeam,
    LightState<bool>? highBeam,
  }) {
    return LightsState(
      leftTurnSignal: leftTurnSignal ?? this.leftTurnSignal,
      rightTurnSignal: rightTurnSignal ?? this.rightTurnSignal,
      hazardBeam: hazardBeam ?? this.hazardBeam,
      sideBeam: sideBeam ?? this.sideBeam,
      lowBeam: lowBeam ?? this.lowBeam,
      highBeam: highBeam ?? this.highBeam,
    );
  }
}

extension _ErrorExtension<V, E extends Object> on AsyncData<V, E> {
  E? get error => maybeWhen(
        orElse: (_) => null,
        failure: (payload, error) => error,
      );
}

class LightsCubit extends Cubit<LightsState> with ConsumerBlocMixin {
  LightsCubit({required this.dataSource}) : super(const LightsState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (package) {
      package
        // SideBeam
        ..voidOnModel<SuccessEventUint8Body,
            FrontSideBeamSetIncomingDataSourcePackage>((model) {
          _onNewSideBeam(value: model.value);
        })
        ..voidOnModel<SuccessEventUint8Body,
            TailSideBeamSetIncomingDataSourcePackage>((model) {
          _onNewSideBeam(
            value: model.value,
            front: false,
          );
        })

        // LowBeam
        ..voidOnModel<SuccessEventUint8Body,
            LowBeamSetIncomingDataSourcePackage>((model) {
          emit(state.copyWith(highBeam: AsyncData.success(model.value.toBool)));
        })
        // HighBeam
        ..voidOnModel<SuccessEventUint8Body,
            HighBeamSetIncomingDataSourcePackage>((model) {
          emit(state.copyWith(highBeam: AsyncData.success(model.value.toBool)));
        })
        // HazardBeam
        ..voidOnModel<SuccessEventUint8Body,
            FrontHazardBeamSetIncomingDataSourcePackage>((model) {
          _onNewHazardState(value: model.value);
        })
        ..voidOnModel<SuccessEventUint8Body,
            TailHazardBeamSetIncomingDataSourcePackage>((model) {
          _onNewHazardState(
            value: model.value,
            front: false,
          );
        })
        // TurnSignal
        ..voidOnModel<SuccessEventUint8Body,
            FrontLeftTurnSignalIncomingDataSourcePackage>((model) {
          _onNewTurnSignal(value: model.value);
        })
        ..voidOnModel<SuccessEventUint8Body,
            FrontRightTurnSignalIncomingDataSourcePackage>((model) {
          _onNewTurnSignal(value: model.value, left: false);
        })
        ..voidOnModel<SuccessEventUint8Body,
            TailLeftTurnSignalIncomingDataSourcePackage>((model) {
          _onNewTurnSignal(value: model.value, front: false);
        })
        ..voidOnModel<SuccessEventUint8Body,
            TailRightTurnSignalIncomingDataSourcePackage>((model) {
          _onNewTurnSignal(value: model.value, front: false, left: false);
        });
    });
  }

  void _onNewSideBeam({
    bool front = true,
    required int value,
  }) {
    _onNewTwoBoolsState(
      newFeatureState: state.sideBeam.copyWith(
        payload: state.sideBeam.payload.copyWith(
          first: front ? value.toBool : null,
          second: front ? null : value.toBool,
        ),
      ),
      newStateBuilder: (current) => state.copyWith(sideBeam: current),
    );
  }

  void _onNewHazardState({
    bool front = true,
    required int value,
  }) {
    _onNewTwoBoolsState(
      newFeatureState: state.hazardBeam.copyWith(
        payload: state.hazardBeam.payload.copyWith(
          first: front ? value.toBool : null,
          second: front ? null : value.toBool,
        ),
      ),
      newStateBuilder: (newState) => state.copyWith(hazardBeam: newState),
    );
  }

  void _onNewTurnSignal({
    bool front = true,
    bool left = true,
    required int value,
  }) {
    _onNewTwoBoolsState(
      newFeatureState: left
          ? state.leftTurnSignal.copyWith(
              payload: state.leftTurnSignal.payload.copyWith(
                first: front ? value.toBool : null,
                second: front ? null : value.toBool,
              ),
            )
          : state.rightTurnSignal.copyWith(
              payload: state.rightTurnSignal.payload.copyWith(
                first: front ? value.toBool : null,
                second: front ? null : value.toBool,
              ),
            ),
      newStateBuilder: (newState) => left
          ? state.copyWith(leftTurnSignal: newState)
          : state.copyWith(rightTurnSignal: newState),
    );
  }

  void _onNewTwoBoolsState({
    required AsyncData<TwoBoolsState, LightsStateError> newFeatureState,
    required LightsState Function(
      AsyncData<TwoBoolsState, LightsStateError> newState,
    ) newStateBuilder,
  }) {
    final newFeaturePayload = newFeatureState.payload;
    final waitingFor = newFeaturePayload.waitingForSwitch;

    if (waitingFor == null || waitingFor == newFeaturePayload.bothOn) {
      emit(
        newStateBuilder(
          AsyncData.success(
            newFeaturePayload.copyWith(
              setWaitingForSwitchToNull: true,
            ),
          ),
        ),
      );

      return;
    }

    emit(newStateBuilder(newFeatureState));
  }

  @protected
  final DataSource dataSource;

  void _sendSubscriptionPackages(List<DataSourceParameterId> parameterIds) {
    dataSource.sendPackages(
      parameterIds
          .map((e) => OutgoingSubscribePackage(parameterId: e))
          .toList(),
    );
  }

  void _sendSetValuePackages(
    List<DataSourceParameterId> parameterIds,
    int value,
  ) {
    dataSource.sendPackages(
      parameterIds
          .map(
            (e) => OutgoingSetValuePackage(
              parameterId: e,
              setValueBody: SetUint8Body(value: value),
            ),
          )
          .toList(),
    );
  }

  // subscribe methods
  void subscribeToSideBeam() {
    _subscribeTo<TwoBoolsState>(
      kSideBeamParameterIds,
      newFeatureStateBuilder: () => state.sideBeam,
      newStateBuilder: (newState) => state.copyWith(sideBeam: newState),
      loadingState: const TwoBoolsState.off(),
    );
  }

  void subscribeToTurnSignals() {
    _subscribeTo<TwoBoolsState>(
      kLeftTurnSignalParameterIds,
      newFeatureStateBuilder: () => state.leftTurnSignal,
      newStateBuilder: (newState) => state.copyWith(leftTurnSignal: newState),
      loadingState: const TwoBoolsState.off(),
    );
    _subscribeTo<TwoBoolsState>(
      kRightTurnSignalParameterIds,
      newFeatureStateBuilder: () => state.rightTurnSignal,
      newStateBuilder: (newState) => state.copyWith(rightTurnSignal: newState),
      loadingState: const TwoBoolsState.off(),
    );
  }

  void subscribeToHazardBeam() {
    _subscribeTo<TwoBoolsState>(
      kHazardBeamParameterIds,
      newFeatureStateBuilder: () => state.hazardBeam,
      newStateBuilder: (newState) => state.copyWith(hazardBeam: newState),
      loadingState: const TwoBoolsState.off(),
    );
  }

  void subscribeToLowBeam() {
    _subscribeTo<bool>(
      kLowBeamParameterIds,
      newFeatureStateBuilder: () => state.lowBeam,
      newStateBuilder: (newState) => state.copyWith(lowBeam: newState),
      loadingState: false,
    );
  }

  void subscribeToHighBeam() {
    _subscribeTo<bool>(
      kHighBeamParameterIds,
      newFeatureStateBuilder: () => state.highBeam,
      newStateBuilder: (newState) => state.copyWith(highBeam: newState),
      loadingState: false,
    );
  }

  void _subscribeTo<T>(
    List<DataSourceParameterId> parameterIds, {
    required AsyncData<T, LightsStateError> Function() newFeatureStateBuilder,
    required LightsState Function(
      AsyncData<T, LightsStateError> newState,
    ) newStateBuilder,
    required T loadingState,
  }) {
    emit(newStateBuilder(AsyncData.loading(loadingState)));

    _sendSubscriptionPackages(parameterIds);

    Future<void>.delayed(const Duration(seconds: 1)).then((value) {
      if (isClosed) return;

      final newFeature = newFeatureStateBuilder();
      if (newFeature.isExecuted) return;

      emit(
        newStateBuilder(
          newFeature.inFailure(
            const LightsStateError.timeout(),
          ),
        ),
      );
    });
  }

  static const kSideBeamParameterIds = [
    DataSourceParameterId.frontSideBeam(),
    DataSourceParameterId.tailSideBeam()
  ];

  static const kLeftTurnSignalParameterIds = [
    DataSourceParameterId.frontLeftTurnSignal(),
    DataSourceParameterId.tailLeftTurnSignal(),
  ];

  static const kRightTurnSignalParameterIds = [
    DataSourceParameterId.frontRightTurnSignal(),
    DataSourceParameterId.tailRightTurnSignal(),
  ];

  static const kHazardBeamParameterIds = [
    DataSourceParameterId.frontHazardBeam(),
    DataSourceParameterId.tailHazardBeam(),
  ];

  static const kLowBeamParameterIds = [
    DataSourceParameterId.lowBeam(),
  ];
  static const kHighBeamParameterIds = [
    DataSourceParameterId.highBeam(),
  ];

  void toggleSideBeam() {
    _toggleTwoBools(
      newStateBuilder: (newState) => state.copyWith(sideBeam: newState),
      newFeatureStateBuilder: () => state.sideBeam,
      parameterIds: kSideBeamParameterIds,
    );
  }

  void _toggleLeftTurnSignal() {
    _toggleTwoBools(
      newStateBuilder: (newState) => state.copyWith(leftTurnSignal: newState),
      newFeatureStateBuilder: () => state.leftTurnSignal,
      parameterIds: kLeftTurnSignalParameterIds,
    );
  }

  void toggleLeftTurnSignal() {
    if (state.rightTurnSignal.payload.isOn) _toggleRightTurnSignal();
    if (state.hazardBeam.payload.isOn) _toggleHazardBeam();

    _toggleLeftTurnSignal();
  }

  void _toggleRightTurnSignal() {
    _toggleTwoBools(
      newStateBuilder: (newState) => state.copyWith(rightTurnSignal: newState),
      newFeatureStateBuilder: () => state.rightTurnSignal,
      parameterIds: kRightTurnSignalParameterIds,
    );
  }

  void toggleRightTurnSignal() {
    if (state.leftTurnSignal.payload.isOn) _toggleLeftTurnSignal();
    if (state.hazardBeam.payload.isOn) _toggleHazardBeam();

    _toggleRightTurnSignal();
  }

  void _toggleHazardBeam() {
    _toggleTwoBools(
      newStateBuilder: (newState) => state.copyWith(hazardBeam: newState),
      newFeatureStateBuilder: () => state.hazardBeam,
      parameterIds: kHazardBeamParameterIds,
    );
  }

  void toggleHazardBeam() {
    if (state.leftTurnSignal.payload.isOn) _toggleLeftTurnSignal();
    if (state.rightTurnSignal.payload.isOn) _toggleRightTurnSignal();

    _toggleHazardBeam();
  }

  void toggleLowBeam() {
    _toggleBool(
      newFeatureStateBuilder: () => state.lowBeam,
      newStateBuilder: (newState) => state.copyWith(lowBeam: newState),
      parameterIds: kLowBeamParameterIds,
    );
  }

  void toggleHighBeam() {
    _toggleBool(
      newFeatureStateBuilder: () => state.highBeam,
      newStateBuilder: (newState) => state.copyWith(highBeam: newState),
      parameterIds: kHighBeamParameterIds,
    );
  }

  void _toggleBool({
    required AsyncData<bool, LightsStateError> Function()
        newFeatureStateBuilder,
    required LightsState Function(
      AsyncData<bool, LightsStateError> newState,
    ) newStateBuilder,
    required List<DataSourceParameterId> parameterIds,
  }) {
    final currentState = newFeatureStateBuilder();
    if (!currentState.isExecuted) return;

    emit(newStateBuilder(const AsyncData.loading(false)));
    final setTo = !currentState.payload;
    _sendSetValuePackages(
      parameterIds,
      setTo.toInt,
    );

    Future<void>.delayed(const Duration(seconds: 1)).then(
      (value) {
        if (isClosed) return;
        final currentState = newFeatureStateBuilder();

        final payload = currentState.payload;

        if (payload != setTo) {
          emit(
            newStateBuilder(
              AsyncData.failure(
                payload,
                const LightsStateError.timeout(),
              ),
            ),
          );
        }
      },
    );
  }

  void _toggleTwoBools({
    required AsyncData<TwoBoolsState, LightsStateError> Function()
        newFeatureStateBuilder,
    required LightsState Function(
      AsyncData<TwoBoolsState, LightsStateError> newState,
    ) newStateBuilder,
    required List<DataSourceParameterId> parameterIds,
  }) {
    final currentState = newFeatureStateBuilder();
    if (!currentState.isExecuted) return;

    emit(
      newStateBuilder(
        AsyncData.loading(
          const TwoBoolsState.off().copyWith(
            waitingForSwitch: currentState.payload.oppositeBool,
          ),
        ),
      ),
    );

    _sendSetValuePackages(
      parameterIds,
      currentState.payload.oppositeValue,
    );

    Future<void>.delayed(const Duration(seconds: 1)).then((value) {
      if (isClosed) return;
      final currentState = newFeatureStateBuilder();
      final payload = currentState.payload;

      if (!currentState.payload.differs &&
          currentState.isSuccess &&
          payload.waitingForSwitch == null) return;

      if (payload.differs || payload.waitingForSwitch != payload.isOn) {
        final failure = payload.differs
            ? LightsStateError.differs(
                first: payload.first,
                second: payload.second,
              )
            : const LightsStateError.timeout();

        emit(
          newStateBuilder(
            AsyncData.failure(
              payload,
              failure,
            ),
          ),
        );
      }
    });
  }
}

extension on int {
  bool get toBool => this == 0xFF;
}

extension on bool {
  int get toInt => this ? 0xFF : 0;
}
