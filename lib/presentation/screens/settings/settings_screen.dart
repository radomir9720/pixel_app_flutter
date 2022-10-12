import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/settings_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/settings_base_layout.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SettingsBaseLayout(
        buttons: [
          SettingsButton(
            icon: PixelIcons.usb,
            title: context.l10n.dataSourceButtonCaption,
            onPressed: () {
              context.router.push(const DataSourceRoute());
            },
          ),
          SettingsButton(
            icon: PixelIcons.fastActions,
            title: context.l10n.fastActionsButtonCaption,
            onPressed: () {},
          ),
          SettingsButton(
            icon: PixelIcons.licenses,
            title: context.l10n.licencesButtonCaption,
            onPressed: () {},
          ),
          SettingsButton(
            icon: PixelIcons.about,
            title: context.l10n.aboutButtonCaption,
            onPressed: () {},
          ),
        ],
        screenTitle: context.l10n.settingScreenTitle,
      ),
    );
  }
}
