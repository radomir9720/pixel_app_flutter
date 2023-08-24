import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'update_user_defined_button_bloc.freezed.dart';

@freezed
class UpdateUserDefinedButtonEvent extends EffectEvent
    with _$UpdateUserDefinedButtonEvent {
  const factory UpdateUserDefinedButtonEvent.update(UserDefinedButton button) =
      _Update;
}

typedef UpdateUserDefinedButtonState = AsyncState<Object>;

class UpdateUserDefinedButtonBloc
    extends Bloc<UpdateUserDefinedButtonEvent, UpdateUserDefinedButtonState>
    with BlocEventHandlerMixin {
  UpdateUserDefinedButtonBloc({required this.storage})
      : super(const UpdateUserDefinedButtonState.initial()) {
    handleEvent<_Update, Result<WriteUserDefinedButtonsStorageError, void>>(
      inLoading: state.inLoading,
      inFailure: state.inFailure,
      action: (event) => storage.append(event.button),
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
