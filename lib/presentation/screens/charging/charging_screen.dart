import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/atoms/charging_screen_section_subtitle.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/atoms/charging_screen_section_title.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/molecules/general_cells_voltage.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/molecules/general_info_section.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/molecules/mos_and_balancer_temperature.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/molecules/temperature_sensors_section.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/molecules/voltage_cells_section.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/responsive_padding.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/organisms/title_wrapper.dart';
import 'package:re_widgets/re_widgets.dart';

class ChargingScreen extends StatefulWidget {
  const ChargingScreen({super.key});

  @override
  State<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends State<ChargingScreen> {
  @override
  void initState() {
    super.initState();
    startUpdating();
    context.router.root.addListener(onRootChange);
  }

  void onRootChange() {
    final route = context.router.topRoute;
    if (route.name == ChargingRoute.name) {
      startUpdating();
      return;
    }
    cancelUpdating();
  }

  void startUpdating() {
    context.read<BatteryDataCubit>()
      ..startUpdatingTemperature()
      ..startUpdatingVoltage();
  }

  void cancelUpdating() {
    context.read<BatteryDataCubit>()
      ..cancelUpdatingTemperature()
      ..cancelUpdatingVoltage();
  }

  @override
  void dispose() {
    cancelUpdating();
    context.router.root.removeListener(onRootChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsivePadding(
      child: TitleWrapper(
        title: context.l10n.batteryTabTitle,
        body: FadeCustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ChargingScreenSectionTitle(
              title: context.l10n.chargingGeneralTabTitle,
            ),
            const GeneralInfoSection(),
            //
            ChargingScreenSectionTitle(
              title: context.l10n.chargingTemperatureTabTitle,
            ),
            const MOSAndBalancerTemperature(),
            ChargingScreenSectionSubitle(
              subtitle: context.l10n.sensorsSectionSubtitle,
            ),
            const TemperatureSensorsSection(),
            //
            ChargingScreenSectionTitle(
              title: context.l10n.chargingVoltageTabTitle,
            ),
            const GeneralCellsVoltage(),
            ChargingScreenSectionSubitle(
              subtitle: context.l10n.cellsSectionSubtitle,
            ),
            const VoltageCellsSection(),
            //
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
