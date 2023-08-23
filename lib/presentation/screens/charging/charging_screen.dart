import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/tabs/general_info_tab.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/tabs/temperature_info_tab.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/tabs/voltage_info_tab.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/responsive_padding.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/organisms/title_wrapper.dart';

class ChargingScreen extends StatelessWidget {
  const ChargingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: DefaultTabController(
        length: 3,
        child: TitleWrapper(
          title: context.l10n.batteryTabTitle,
          body: Column(
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
    );
  }
}
