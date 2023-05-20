import 'package:flutter/material.dart' hide OverlayState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:re_widgets/re_widgets.dart';

class SwitchOverlayTile extends StatelessWidget {
  const SwitchOverlayTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OverlayBloc, OverlayState>(
      listenWhen: (previous, current) => current.isFailure,
      listener: (context, state) {
        context.showSnackBar(
          context.l10n.errorSwitchingStatisticsOverlayMessage,
        );
      },
      builder: (context, state) {
        return SwitchListTile(
          value: state.payload,
          onChanged: (v) async {
            bool? granted;
            if (v) {
              granted = await FlutterOverlayWindow.isPermissionGranted();
              if (!granted) {
                granted = await FlutterOverlayWindow.requestPermission();
              }
            }
            if (context.mounted && (!v || (granted ?? false))) {
              context.read<OverlayBloc>().add(OverlayEvent.set(enabled: v));
            }
          },
          title: Text(context.l10n.overlayStatisticsAboveAnotherAppsTileTitle),
          subtitle: Text(
            context.l10n.overlayStatisticsAboveAnotherAppsHint,
          ),
        );
      },
    );
  }
}
