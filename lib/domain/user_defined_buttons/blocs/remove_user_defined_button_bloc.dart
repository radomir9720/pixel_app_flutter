import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'remove_user_defined_button_bloc.freezed.dart';

@freezed
class RemoveUserDefinedBurronEvent extends EffectEvent
    with _$RemoveUserDefinedBurronEvent {
  const factory RemoveUserDefinedBurronEvent.remove(int buttonId) = _Remove;
}

typedef RemoveUserDefinedBurronState = AsyncState<Object>;

class RemoveUserDefinedBurronBloc
    extends Bloc<RemoveUserDefinedBurronEvent, RemoveUserDefinedBurronState>
    with BlocEventHandlerMixin {
  RemoveUserDefinedBurronBloc({
    required this.storage,
  }) : super(const RemoveUserDefinedBurronState.initial()) {
    handleEvent<_Remove,
        Result<DeleteByIdUserDefinedButtonsStorageError, void>>(
      inLoading: state.inLoading,
      inFailure: state.inFailure,
      action: (event) {
        return storage.deleteById(event.buttonId);
      },
      onActionResult: (actionResult) async {
        return actionResult.when(
          error: state.inFailure,
          value: (_) => state.inSuccess(),
        );
      },
    );
  }

  @protected
  final UserDefinedButtonsStorage storage;
}
