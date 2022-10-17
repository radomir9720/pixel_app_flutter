import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/settings/settings.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'always_on_display_toggle_bloc.freezed.dart';

@freezed
class AlwaysOnDisplayToggleEvent with _$AlwaysOnDisplayToggleEvent {
  const factory AlwaysOnDisplayToggleEvent.toggle() = _Toggle;
  const factory AlwaysOnDisplayToggleEvent.init() = _Init;
}

typedef AlwaysOnDisplayToggleState = AsyncData<bool, Object>;

class AlwaysOnDisplayToggleBloc
    extends Bloc<AlwaysOnDisplayToggleEvent, AlwaysOnDisplayToggleState> {
  AlwaysOnDisplayToggleBloc({
    required this.service,
    required this.storage,
    bool defaultValue = false,
  }) : super(AlwaysOnDisplayToggleState.initial(defaultValue)) {
    on<_Toggle>(_toggle);
    on<_Init>(_init);
  }

  @protected
  final AlwaysOnDisplayService service;

  @protected
  final AlwaysOnDisplayStorage storage;

  Future<void> _toggle(
    AlwaysOnDisplayToggleEvent event,
    Emitter<AlwaysOnDisplayToggleState> emit,
  ) async {
    emit(state.inLoading());

    try {
      final result = await service.toggle(enable: !state.value);
      emit(
        await result.when(
          error: (e) async => state.inFailure(),
          value: (enabled) async {
            await storage.write(enable: enabled);
            return AsyncData.success(enabled);
          },
        ),
      );
    } catch (e) {
      emit(state.inFailure());

      rethrow;
    }
  }

  Future<void> _init(
    AlwaysOnDisplayToggleEvent event,
    Emitter<AlwaysOnDisplayToggleState> emit,
  ) async {
    emit(state.inLoading());

    try {
      emit(
        await storage.read().when(
          error: (e) async {
            if (e == AlwaysOnDisplayStorageReadError.noValue) {
              return state;
            }
            return state.inFailure();
          },
          value: (enable) async {
            final result = await service.toggle(enable: enable);
            return result.when(
              error: (e) => state.inFailure(),
              value: (_) => AsyncData.success(enable),
            );
          },
        ),
      );
    } catch (e) {
      emit(state.inFailure());

      rethrow;
    }
  }
}
