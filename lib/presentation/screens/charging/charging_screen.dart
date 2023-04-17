import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/tabs/general_info_tab.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/tabs/temperature_info_tab.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/tabs/voltage_info_tab.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';

class ChargingScreen extends StatelessWidget {
  const ChargingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);

    final titlePadding = screenData.whenType(
      orElse: () => const EdgeInsets.only(left: 32, top: 37),
      handset: () => EdgeInsets.zero,
    );
    final bodyPadding = screenData.whenType(
      orElse: () => EdgeInsets.only(
        left: !screenData.type.isHandset && screenData.size.width > 700
            ? 190
            : 100,
        right: 32,
        bottom: 16,
      ),
      handset: () => EdgeInsets.zero,
    );

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: titlePadding,
            child: Text(
              context.l10n.chargingTabTitle,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: bodyPadding,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: context.l10n.chargingGeneralTabTitle),
                      Tab(text: context.l10n.chargingTemperatureTabTitle),
                      Tab(text: context.l10n.chargingVoltageTabTitle),
                    ],
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        GeneralInfoTab(),
                        TemperatureInfoTab(),
                        VoltageInfoTab(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
