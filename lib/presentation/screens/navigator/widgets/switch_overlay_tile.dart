import 'package:app_settings/app_settings.dart';
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
          onChanged: (enable) async {
            if (!enable) {
              context
                  .read<OverlayBloc>()
                  .add(OverlayEvent.set(enabled: enable));
              return;
            }

            bool? granted;
            granted = await FlutterOverlayWindow.isPermissionGranted();
            if (!granted) {
              granted = await FlutterOverlayWindow.requestPermission();
            }
            if (context.mounted) {
              if (!(granted ?? false)) {
                await context.showSnackBar(
                  context.l10n.noDisplayOverOtherAppsPermissionErrorMessage,
                  action: SnackBarAction(
                    label: context.l10n.openSettingsButtonCaption,
                    onPressed: AppSettings.openAppSettings,
                  ),
                );
                return;
              }

              context
                  .read<OverlayBloc>()
                  .add(OverlayEvent.set(enabled: enable));
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
