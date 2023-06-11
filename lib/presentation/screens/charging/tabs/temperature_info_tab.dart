import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/charging_screen_list_tile.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/update_button.dart';

class TemperatureInfoTab extends StatelessWidget {
  const TemperatureInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const UpdateButton(
        updateIds: [
          DataSourceParameterId.temperatureFirstBatch(),
          DataSourceParameterId.temperatureSecondBatch(),
          DataSourceParameterId.temperatureThirdBatch(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryTemperatureFirstBatch>(
            selector: (state) => state.temperatureFirstBatch,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.mosTileTitle,
                      trailing: context.l10n.celsiusValue(state.mos),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.balancerTileTitle,
                      trailing: context.l10n.celsiusValue(state.balancer),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(1),
                      trailing: context.l10n.celsiusValue(state.first),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(2),
                      trailing: context.l10n.celsiusValue(state.second),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(3),
                      trailing: context.l10n.celsiusValue(state.third),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(4),
                      trailing: context.l10n.celsiusValue(state.fourth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(5),
                      trailing: context.l10n.celsiusValue(state.fifth),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryTemperatureSecondBatch>(
            selector: (state) => state.temperatureSecondBatch,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(6),
                      trailing: context.l10n.celsiusValue(state.sixth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(7),
                      trailing: context.l10n.celsiusValue(state.seventh),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(8),
                      trailing: context.l10n.celsiusValue(state.eighth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(9),
                      trailing: context.l10n.celsiusValue(state.ninth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(10),
                      trailing: context.l10n.celsiusValue(state.tenth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(11),
                      trailing: context.l10n.celsiusValue(state.eleventh),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(12),
                      trailing: context.l10n.celsiusValue(state.twelfth),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryTemperatureThirdBatch>(
            selector: (state) => state.temperatureThirdBatch,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(13),
                      trailing: context.l10n.celsiusValue(state.thirteenth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(14),
                      trailing: context.l10n.celsiusValue(state.fourteenth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(15),
                      trailing: context.l10n.celsiusValue(state.fifteenth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(16),
                      trailing: context.l10n.celsiusValue(state.sixteenth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(17),
                      trailing: context.l10n.celsiusValue(state.seventeenth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(18),
                      trailing: context.l10n.celsiusValue(state.eighteenth),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(19),
                      trailing: context.l10n.celsiusValue(state.nineteenth),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
