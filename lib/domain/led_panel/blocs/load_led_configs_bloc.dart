import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'load_led_configs_bloc.freezed.dart';

@freezed
class LoadLEDConfigsEvent extends EffectEvent with _$LoadLEDConfigsEvent {
  const factory LoadLEDConfigsEvent.load() = _Load;
}

typedef LoadLEDConfigsState = AsyncState<ReadLEDConfigsStorageError>;

class LoadLEDConfigsBloc extends Bloc<LoadLEDConfigsEvent, LoadLEDConfigsState>
    with BlocEventHandlerMixin {
  LoadLEDConfigsBloc({required this.storage})
      : super(const LoadLEDConfigsState.initial()) {
    handleEvent<_Load,
        Result<ReadLEDConfigsStorageError, List<LEDPanelConfig>>>(
      inLoading: () => state.inLoading(),
      inFailure: () => state.inFailure(),
      action: storage.read,
      onActionResult: (actionResult) async {
        return actionResult.when(
          error: state.inFailure,
          value: (_) => const LoadLEDConfigsState.success(),
        );
      },
    );
  }

  @protected
  final LEDConfigsStorage storage;
}
