import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/fan_indicator.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/interface_button.dart';

class MainInterfacesWidget extends StatelessWidget {
  const MainInterfacesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InterfaceButton.withTitle(
            icon: PixelIcons.belt,
            onPressed: () {},
            title: context.l10n.leftBeltButtonCaption,
          ),
          InterfaceButton.withTitle(
            icon: PixelIcons.windshieldBlower,
            disabled: true,
            onPressed: () {},
            title: context.l10n.frontButtonCaption,
          ),
          InterfaceButton.withTitle(
            icon: PixelIcons.airflow,
            onPressed: () {},
            title: context.l10n.airflowButtonCaption,
          ),
          InterfaceButton(
            icon: PixelIcons.fan,
            onPressed: () {},
            bottom: const FanIndicator(power: 3),
          ),
          InterfaceButton.withTitle(
            icon: PixelIcons.belt,
            title: context.l10n.rightBeltButtonCaption,
            onPressed: () {},
            disabled: true,
          ),
        ].map((e) => Expanded(child: e)).toList(),
      ),
    );
  }
}
