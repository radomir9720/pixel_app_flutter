import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:provider/single_child_widget.dart';
import 'package:re_widgets/re_widgets.dart';

class LightStateErrorListener extends SingleChildStatelessWidget {
  const LightStateErrorListener({super.key, super.child});

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return BlocListener<LightsCubit, LightsState>(
      listenWhen: (previous, current) {
        final errors = current.whenFailure<MapEntry<String, LightsStateError>>(
          previous,
          leftTurnSignal: (error) =>
              MapEntry(context.l10n.leftBlinkerButtonCaption, error),
          rightTurnSignal: (error) =>
              MapEntry(context.l10n.rightBlinkerButtonCaption, error),
          hazardBeam: (error) =>
              MapEntry(context.l10n.hazardBeamButtonCaption, error),
          sideBeam: (error) =>
              MapEntry(context.l10n.parkingLightsButtonCaption, error),
          lowBeam: (error) =>
              MapEntry(context.l10n.lowBeamButtonCaption, error),
          highBeam: (error) =>
              MapEntry(context.l10n.highBeamButtonCaption, error),
          reverse: (error) =>
              MapEntry(context.l10n.reverseLightButtonCaption, error),
          brake: (error) =>
              MapEntry(context.l10n.brakeLightButtonCaption, error),
          cabin: (error) =>
              MapEntry(context.l10n.cabinLightButtonCaption, error),
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
