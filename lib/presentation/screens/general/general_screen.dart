import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/fast_actions_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/speed_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/statistic_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/tablet/organisms/car_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/tablet/organisms/tablet_upper_info_panel.dart';

class GeneralScreen extends StatelessWidget {
  const GeneralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: screenData.whenType(
        orElse: () => const TabletGeneralScreenBody(),
        handset: () => const HandsetGeneralScreenBody(),
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
          const TabletUpperInfoPanel(),
          Positioned(
            right: MediaQuery.of(context).size.width * .25,
            bottom: MediaQuery.of(context).size.height * .25,
            child: const CarWidget(),
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

    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 32, horizontal: 16).copyWith(
        left: landscape ? 82 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SpeedWidget(),
                if (landscape) const StatisticWidget(),
              ],
            ),
          ),
          const SizedBox(height: 32),
          if (!landscape) ...[
            const StatisticWidget(useWrap: true),
            const SizedBox(height: 32),
          ],
          if (landscape)
            FastActionsWidget.oneRow()
          else
            FastActionsWidget.manyRows()
        ],
      ),
    );
  }
}
