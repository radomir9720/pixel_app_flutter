import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'remove_led_config_bloc.freezed.dart';

@freezed
class RemoveLEDConfigEvent extends EffectEvent with _$RemoveLEDConfigEvent {
  const factory RemoveLEDConfigEvent.remove(int id) = _Remove;
}

typedef RemoveLEDConfigState = AsyncState<WriteLEDConfigsStorageError>;

class RemoveLEDConfigBloc
    extends Bloc<RemoveLEDConfigEvent, RemoveLEDConfigState>
    with BlocEventHandlerMixin {
  RemoveLEDConfigBloc({required this.storage})
      : super(const RemoveLEDConfigState.initial()) {
    on<_Remove>(
      (event, emit) => handle<Result<WriteLEDConfigsStorageError, void>>(
        event: event,
        emit: emit,
        inLoading: () => state.inLoading(),
        inFailure: () => state.inFailure(),
        action: () => storage.write(
          storage.data.whereNot((element) => element.id == event.id).toList(),
        ),
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
