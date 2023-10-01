import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/glue_title.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/icon_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/main_interfaces_widget.dart';

class BottomInterfacesMenu extends StatelessWidget {
  const BottomInterfacesMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);
    final screenType = screenData.type;
    final isPortrait = screenData.isPortrait;
    final isHandset = screenType.isHandset;
    final displayTitleAtTheBottom = !isPortrait || !screenType.isHandset;

    return Column(
      children: [
        if (screenType.isHandset && isPortrait) ...[
          const MainInterfacesWidget(),
          const SizedBox(height: 18),
        ],
        Row(
          crossAxisAlignment:
              isPortrait ? CrossAxisAlignment.center : CrossAxisAlignment.end,
          children: [
            //
            Expanded(
              child: GlueTitle(
                alignment: Alignment.centerLeft,
                title: context.l10n.settingsButtonCaption,
                side: displayTitleAtTheBottom
                    ? GlueTitleSide.bottom
                    : GlueTitleSide.right,
                child: PIconButton(
                  onPressed: () {
                    context.router.push(const SettingsFlow());
                  },
                  icon: PixelIcons.settings,
                  size: isHandset
                      ? PIconButtonSize.small
                      : PIconButtonSize.normal,
                ),
              ),
            ),
            //
            if (!screenType.isHandset || !isPortrait)
              const Expanded(
                flex: 3,
                child: MainInterfacesWidget(),
              ),
            //
            Expanded(
              child: GlueTitle(
                alignment: Alignment.centerRight,
                title: context.l10n.powerOffButtonCaption,
                side: displayTitleAtTheBottom
                    ? GlueTitleSide.bottom
                    : GlueTitleSide.left,
                child: PIconButton.error(
                  onPressed: () {},
                  icon: PixelIcons.power,
                  size: isHandset
                      ? PIconButtonSize.small
                      : PIconButtonSize.normal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: MediaQuery.paddingOf(context).bottom,
        ),
      ],
    );
  }
}
