import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:re_seedwork/re_seedwork.dart';

part 'add_user_defined_button_bloc.freezed.dart';

@freezed
class AddUserDefinedButtonEvent extends EffectEvent
    with _$AddUserDefinedButtonEvent {
  const factory AddUserDefinedButtonEvent.add(UserDefinedButton button) = _Add;
}

typedef AddUserDefinedButtonState = AsyncState<Object>;

class AddUserDefinedButtonBloc
    extends Bloc<AddUserDefinedButtonEvent, AddUserDefinedButtonState>
    with BlocEventHandlerMixin {
  AddUserDefinedButtonBloc({required this.storage})
      : super(const AddUserDefinedButtonState.initial()) {
    handleEvent<_Add, Result<WriteUserDefinedButtonsStorageError, void>>(
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
