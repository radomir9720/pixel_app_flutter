import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/close_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/settings_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);

    return GradientScaffold(
      body: screenData.whenType(
        handset: () => const SettingsBaseLayout(),
        orElse: () => SettingsBaseLayout(
          bodyPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .15,
          ),
          buttonFontSize: 16,
          closeButtonPadding: const EdgeInsets.symmetric(
            horizontal: 38,
            vertical: 33,
          ),
        ),
      ),
    );
  }
}

class SettingsBaseLayout extends StatelessWidget {
  const SettingsBaseLayout({
    super.key,
    this.closeButtonPadding = const EdgeInsets.all(16),
    this.bodyPadding = const EdgeInsets.symmetric(horizontal: 16),
    this.buttonFontSize = 14,
  });

  @protected
  final EdgeInsets bodyPadding;

  @protected
  final EdgeInsets closeButtonPadding;

  @protected
  final double buttonFontSize;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: bodyPadding,
                  child: Column(
                    children: [
                      Text(
                        context.l10n.settingScreenTitle,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 32),
                      GridView.extent(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        maxCrossAxisExtent: 240,
                        childAspectRatio: 1.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          SettingsButton(
                            icon: PixelIcons.usb,
                            title: context.l10n.dataSourceButtonCaption,
                            onPressed: () {
                              context.router.push(const DataSourceRoute());
                            },
                            titleFontSize: buttonFontSize,
                          ),
                          SettingsButton(
                            icon: PixelIcons.fastActions,
                            title: context.l10n.fastActionsButtonCaption,
                            onPressed: () {},
                            titleFontSize: buttonFontSize,
                          ),
                          SettingsButton(
                            icon: PixelIcons.licenses,
                            title: context.l10n.licencesButtonCaption,
                            onPressed: () {},
                            titleFontSize: buttonFontSize,
                          ),
                          SettingsButton(
                            icon: PixelIcons.about,
                            title: context.l10n.aboutButtonCaption,
                            onPressed: () {},
                            titleFontSize: buttonFontSize,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: closeButtonPadding,
            child: const PCloseButton(),
          )
        ],
      ),
    );
  }
}
