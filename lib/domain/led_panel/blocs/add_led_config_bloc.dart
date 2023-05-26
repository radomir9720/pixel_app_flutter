import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'add_led_config_bloc.freezed.dart';

@freezed
class AddLEDConfigEvent extends EffectEvent with _$AddLEDConfigEvent {
  const factory AddLEDConfigEvent.add(LEDPanelConfig config) = _Add;
}

typedef AddLEDConfigState = AsyncState<WriteLEDConfigsStorageError>;

class AddLEDConfigBloc extends Bloc<AddLEDConfigEvent, AddLEDConfigState>
    with BlocEventHandlerMixin {
  AddLEDConfigBloc({required this.storage})
      : super(const AddLEDConfigState.initial()) {
    on<_Add>(
      (event, emit) => handle<Result<WriteLEDConfigsStorageError, void>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inFailure(),
        action: () => storage.write([
          ...storage.data,
          event.config,
        ]),
        onActionResult: (actionResult) async {
          return actionResult.when(
            error: state.inFailure,
            value: (_) => state.inSuccess(),
          );
        },
      ),
    );
  }

  @protected
  final LEDConfigsStorage storage;
}
