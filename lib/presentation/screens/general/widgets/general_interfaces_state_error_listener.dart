import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:provider/single_child_widget.dart';
import 'package:re_widgets/re_widgets.dart';

class GeneralInterfacesStateErrorListener extends SingleChildStatelessWidget {
  const GeneralInterfacesStateErrorListener({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<GeneralInterfacesCubit, GeneralInterfacesState>(
      listenWhen: (previous, current) {
        final errors = current.whenFailure<MapEntry<String, ToggleStateError>>(
          previous,
          leftDoor: (error) =>
              MapEntry(context.l10n.leftDoorInterfaceTitle, error),
          rightDoor: (error) =>
              MapEntry(context.l10n.rightDoorInterfaceTitle, error),
          wipers: (error) =>
              MapEntry(context.l10n.windscreenWipersInterfaceTitle, error),
        );

        if (errors.isEmpty) return false;

        for (final error in errors) {
          final reason = error.value.when(
            timeout: () => context.l10n.positiveAnswerDidNotComeErrorMessage,
            mainECUError: () => context.l10n.errorFromMainECUErrorMessage,
            differs: () =>
                context.l10n.notAllBlocksReturnedSuccessResponseErrorMessage,
          );
          context.showSnackBar(
            context.l10n.errorSwitchingFeatureMessage(
              error.key.toLowerCase(),
              reason,
            ),
          );
        }

        return false;
      },
      listener: (context, state) {},
      child: child,
    );
  }
}
