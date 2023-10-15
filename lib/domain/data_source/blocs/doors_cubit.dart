import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/incoming/incoming_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/outgoing_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:re_seedwork/re_seedwork.dart';

typedef DoorState = AsyncData<bool, ToggleStateError>;

@immutable
class DoorsState with EquatableMixin {
  const DoorsState({required this.left, required this.right});

  const DoorsState.initial()
      : left = const AsyncData.initial(false),
        right = const AsyncData.initial(false);

  final DoorState left;
  final DoorState right;

  @override
  List<Object?> get props => [left, right];

  DoorsState copyWith({
    DoorState? left,
    DoorState? right,
  }) {
    return DoorsState(
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }

  bool get hasFailureState => [left, right].any((element) => element.isFailure);

  List<R> whenFailure<R>(
    DoorsState prevState, {
    required R Function(ToggleStateError error) left,
    required R Function(ToggleStateError error) right,
  }) {
    final leftError = this.left.error;
    final rightError = this.right.error;

    final errors = [
      _filterError(
        leftError,
        prevState.left.error,
        left,
      ),
      _filterError(
        rightError,
        prevState.right.error,
        right,
      ),
    ].whereType<R>().toList();

    return errors;
  }

  R? _filterError<R>(
    ToggleStateError? current,
    ToggleStateError? prev,
    R Function(ToggleStateError) callback,
  ) {
    if (current == null) return null;
    if (current.isTimeout && prev != null && !prev.isTimeout) return null;
    if (current == prev) return null;
    return callback(current);
  }
}

extension _ErrorExtension<V, E extends Object> on AsyncData<V, E> {
  E? get error => maybeWhen(
        orElse: (_) => null,
        failure: (payload, error) => error,
      );
}

class DoorsCubit extends Cubit<DoorsState> with ConsumerBlocMixin {
  DoorsCubit({
    required this.dataSource,
    this.subscriptionTimeout = kSubscriptionTimeout,
    this.toggleTimeout = kToggleTimeout,
  }) : super(const DoorsState.initial()) {
    subscribe<DataSourceIncomingPackage>(dataSource.packageStream, (package) {
      package
        ..voidOnModel<DoorBody, LeftDoorIncomingDataSourcePackage>((model) {
          emit(state.copyWith(left: AsyncData.success(model.isOpen)));
        })
        ..voidOnModel<DoorBody, RightDoorIncomingDataSourcePackage>((model) {
          emit(state.copyWith(right: AsyncData.success(model.isOpen)));
        });
    });
  }

  @protected
  final Duration toggleTimeout;

  @protected
  final Duration subscriptionTimeout;

  @visibleForTesting
  static const kToggleTimeout = Duration(seconds: 1);

  @visibleForTesting
  static const kSubscriptionTimeout = Duration(seconds: 1);

  @protected
  final DataSource dataSource;

  void subscribeToLeftDoor([
    DataSourceParameterId parameterId =
        const DataSourceParameterId.custom(ButtonFunctionId.leftDoorId),
  ]) {
    _subscribe(
      newStateBuilder: (newState) => state.copyWith(left: newState),
      newFeatureStateBuilder: () => state.left,
      parameterId: parameterId,
    );
  }

  void subscribeToRightDoor([
    DataSourceParameterId parameterId =
        const DataSourceParameterId.custom(ButtonFunctionId.rightDoorId),
  ]) {
    _subscribe(
      newStateBuilder: (newState) => state.copyWith(right: newState),
      newFeatureStateBuilder: () => state.right,
      parameterId: parameterId,
    );
  }

  Future<void> _subscribe({
    required DoorsState Function(
      AsyncData<bool, ToggleStateError> newState,
    ) newStateBuilder,
    required AsyncData<bool, ToggleStateError> Function()
        newFeatureStateBuilder,
    required DataSourceParameterId parameterId,
  }) async {
    emit(newStateBuilder(const AsyncData.loading(false)));

    await dataSource.sendPackage(
      OutgoingSubscribePackage(parameterId: parameterId),
    );

    final failure = await stream
        .where((event) => newFeatureStateBuilder().isExecuted)
        .map<DoorsState?>((event) => null)
        .first
        .timeout(
      subscriptionTimeout,
      onTimeout: () async {
        return newStateBuilder(
          newFeatureStateBuilder().inFailure(
            const ToggleStateError.timeout(),
          ),
        );
      },
    );

    if (isClosed) return;
    if (failure != null) emit(failure);
  }

  void toggleLeftDoor([
    DataSourceParameterId parameterId = const DataSourceParameterId.leftDoor(),
  ]) {
    _toggleBool(
      newFeatureStateBuilder: () => state.left,
      newStateBuilder: (newState) => state.copyWith(left: newState),
      parameterId: parameterId,
    );
  }

  void toggleRightDoor([
    DataSourceParameterId parameterId = const DataSourceParameterId.rightDoor(),
  ]) {
    _toggleBool(
      newFeatureStateBuilder: () => state.right,
      newStateBuilder: (newState) => state.copyWith(right: newState),
      parameterId: parameterId,
    );
  }

  Future<void> _toggleBool({
    required AsyncData<bool, ToggleStateError> Function()
        newFeatureStateBuilder,
    required DoorsState Function(
      AsyncData<bool, ToggleStateError> newState,
    ) newStateBuilder,
    required DataSourceParameterId parameterId,
  }) async {
    final currentState = newFeatureStateBuilder();
    if (!currentState.isExecuted) return;

    final setTo = !currentState.payload;
    emit(newStateBuilder(AsyncData.loading(setTo)));

    await dataSource.sendPackage(
      OutgoingActionRequestPackage(parameterId: parameterId),
    );

    final failure = await stream
        .where((event) => newFeatureStateBuilder().payload == setTo)
        .map<DoorState?>((event) => null)
        .first
        .timeout(
      toggleTimeout,
      onTimeout: () async {
        return AsyncData.failure(
          currentState.payload,
          const ToggleStateError.timeout(),
        );
      },
    );

    if (isClosed) return;
    if (failure != null) emit(newStateBuilder(failure));
  }
}
