import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'navigator_fast_access_bloc.freezed.dart';

@freezed
class NavigatorFastAccessEvent extends EffectEvent
    with _$NavigatorFastAccessEvent {
  const factory NavigatorFastAccessEvent.load() = _Load;
  const factory NavigatorFastAccessEvent.set({required bool value}) = _Set;
}

typedef NavigatorFastAccessState
    = AsyncData<bool, FastAccessNavigatorAppStorageError>;

class NavigatorFastAccessBloc
    extends Bloc<NavigatorFastAccessEvent, NavigatorFastAccessState>
    with BlocEventHandlerMixin {
  NavigatorFastAccessBloc({
    required this.storage,
    this.defaultValue = false,
  }) : super(NavigatorFastAccessState.initial(defaultValue)) {
    on<_Load>(
      (event, emit) =>
          handle<Result<GetFastAccessNavigatorAppStorageError, bool?>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inLoading(),
        action: storage.getFastAccess,
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: (e) => state.inFailure(e),
            value: (value) => AsyncData.success(value ?? defaultValue),
          );
        },
      ),
    );
    on<_Set>(
      (event, emit) =>
          handle<Result<SetFastAccessNavigatorAppStorageError, void>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inLoading(),
        action: () => storage.setFastAccess(
          value: event.value,
        ),
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: (error) => state.inFailure(error),
            value: (_) => AsyncData.success(event.value),
          );
        },
      ),
    );
  }

  @protected
  final NavigatorAppStorage storage;

  @protected
  final bool defaultValue;
}
