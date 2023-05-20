import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'overlay_bloc.freezed.dart';

@freezed
class OverlayEvent extends EffectEvent with _$OverlayEvent {
  const factory OverlayEvent.load() = _Load;
  const factory OverlayEvent.set({required bool enabled}) = _Set;
}

typedef OverlayState = AsyncData<bool, OverlayStorageError>;

class OverlayBloc extends Bloc<OverlayEvent, OverlayState>
    with BlocEventHandlerMixin {
  OverlayBloc({
    required this.storage,
    bool defaultValue = false,
  }) : super(OverlayState.initial(defaultValue)) {
    on<_Load>(
      (event, emit) => handle<Result<ReadEnabledStorageError, bool?>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inFailure(),
        action: storage.readEnabled,
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: state.inFailure,
            value: (v) => AsyncData.success(v ?? defaultValue),
          );
        },
      ),
    );
    on<_Set>(
      (event, emit) => handle<Result<SetEnabledStorageError, void>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inFailure(),
        action: () => storage.setEnabled(value: event.enabled),
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: state.inFailure,
            value: (_) => AsyncData.success(event.enabled),
          );
        },
      ),
    );
  }

  @protected
  final OverlayStorage storage;
}
