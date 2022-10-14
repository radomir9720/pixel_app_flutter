import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
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
              context.router.push(const SelectDataSourceFlow());
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
          if (context.watch<Environment>().isDev)
            SettingsButton(
              icon: Icons.developer_board,
              title: context.l10n.developerToolsButtonCaption,
              onPressed: () {
                context.router.push(const DeveloperToolsFlow());
              },
            ),
        ],
        screenTitle: context.l10n.settingScreenTitle,
        bottom: Text(
          context.l10n.appVersion(context.read<PackageInfo>().version),
          style: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
