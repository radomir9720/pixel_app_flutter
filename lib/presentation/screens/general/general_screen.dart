import 'package:flutter/material.dart';
import 'package:nested/nested.dart';
import 'package:pixel_app_flutter/presentation/screens/general/widgets/car_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/general/widgets/gear_widget.dart';
import 'package:pixel_app_flutter/presentation/screens/general/widgets/led_switcher_button.dart';
import 'package:pixel_app_flutter/presentation/screens/general/widgets/light_state_error_listener.dart';
import 'package:pixel_app_flutter/presentation/screens/general/widgets/overlay_data_sender.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/speed_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/statistic_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/tablet/molecules/blinker_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/tablet/organisms/tablet_upper_info_panel.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);

    return Nested(
      children: const [
        LightStateErrorListener(),
        OverlayDataSender(),
      ],
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: screenData.whenType(
          orElse: () => const TabletGeneralScreenBody(),
          handset: () => const HandsetGeneralScreenBody(),
        ),
      ),
    );
  }
}

class TabletGeneralScreenBody extends StatelessWidget {
  const TabletGeneralScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 37),
      child: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TabletUpperInfoPanel(),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: MediaQuery.of(context).size.height * .3,
            child: const CarWidget(),
          ),
          const Positioned(
            left: 7,
            bottom: 420,
            child: GearWidget(),
          ),
          const Positioned(
            right: 0,
            top: 0,
            child: BlinkerButton(),
          ),
        ],
      ),
    );
  }
}

class HandsetGeneralScreenBody extends StatelessWidget {
  const HandsetGeneralScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final landscape = Screen.of(context).isLandscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpeedWidget(),
              if (landscape) const StatisticWidget() else const GearWidget(),
            ],
          ),
        ),
        if (!landscape) ...[
          const SizedBox(height: 32),
          const StatisticWidget(useWrap: true),
          const SizedBox(height: 32),
          const LEDSwitcherButton(),
        ] else ...[
          const GearWidget(),
          const SizedBox(height: 16),
          const LEDSwitcherButton(),
        ],
      ],
    );
  }
}
