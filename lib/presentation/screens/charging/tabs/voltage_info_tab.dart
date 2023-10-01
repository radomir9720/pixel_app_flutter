import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/charging_screen_list_tile.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/update_button.dart';

class VoltageInfoTab extends StatelessWidget {
  const VoltageInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: const UpdateButton(
        updateIds: [
          DataSourceParameterId.lowVoltageMinMaxDelta(),
          DataSourceParameterId.lowVoltageOneToThree(),
          DataSourceParameterId.lowVoltageFourToSix(),
          DataSourceParameterId.lowVoltageSevenToNine(),
          DataSourceParameterId.lowVoltageTenToTwelve(),
          DataSourceParameterId.lowVoltageThirteenToFifteen(),
          DataSourceParameterId.lowVoltageSixteenToEighteen(),
          DataSourceParameterId.lowVoltageNineteenToTwentyOne(),
          DataSourceParameterId.lowVoltageTwentyTwoToTwentyFour(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          BlocSelector<BatteryDataCubit, BatteryDataState,
              LowVoltageMinMaxDelta>(
            selector: (state) => state.lowVoltageMinMaxDelta,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.minCellsVoltageTileTitle,
                      trailing: context.l10n
                          .voltageValue(state.min.toStringAsFixed(3)),
                      status: state.status,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.maxCellsVoltageTileTitle,
                      trailing: context.l10n
                          .voltageValue(state.max.toStringAsFixed(3)),
                      status: state.status,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.deltaCellsVoltageTileTitle,
                      trailing: context.l10n
                          .voltageValue(state.delta.toStringAsFixed(3)),
                      status: state.status,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageOneToThree>(
            selector: (state) => state.lowVoltageOneToThree,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(1),
                      trailing: context.l10n
                          .voltageValue(state.first.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(2),
                      trailing: context.l10n
                          .voltageValue(state.second.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(3),
                      trailing: context.l10n
                          .voltageValue(state.third.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageFourToSix>(
            selector: (state) => state.lowVoltageFourToSix,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(4),
                      trailing: context.l10n
                          .voltageValue(state.fourth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(5),
                      trailing: context.l10n
                          .voltageValue(state.fifth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(6),
                      trailing: context.l10n
                          .voltageValue(state.sixth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageSevenToNine>(
            selector: (state) => state.lowVoltageSevenToNine,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(7),
                      trailing: context.l10n
                          .voltageValue(state.seventh.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(8),
                      trailing: context.l10n
                          .voltageValue(state.eighth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(9),
                      trailing: context.l10n
                          .voltageValue(state.ninth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageTenToTwelve>(
            selector: (state) => state.lowVoltageTenToTwelve,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(10),
                      trailing: context.l10n
                          .voltageValue(state.tenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(11),
                      trailing: context.l10n
                          .voltageValue(state.eleventh.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(12),
                      trailing: context.l10n
                          .voltageValue(state.twelfth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageThirteenToFifteen>(
            selector: (state) => state.lowVoltageThirteenToFifteen,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(13),
                      trailing: context.l10n
                          .voltageValue(state.thirteenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(14),
                      trailing: context.l10n
                          .voltageValue(state.fourteenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(15),
                      trailing: context.l10n
                          .voltageValue(state.fifteenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageSixteenToEighteen>(
            selector: (state) => state.lowVoltageSixteenToEighteen,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(16),
                      trailing: context.l10n
                          .voltageValue(state.sixteenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(17),
                      trailing: context.l10n
                          .voltageValue(state.seventeenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(18),
                      trailing: context.l10n
                          .voltageValue(state.eighteenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageNineteenToTwentyOne>(
            selector: (state) => state.lowVoltageNineteenToTwentyOne,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(19),
                      trailing: context.l10n
                          .voltageValue(state.nineteenth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(20),
                      trailing: context.l10n
                          .voltageValue(state.twentieth.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(21),
                      trailing: context.l10n
                          .voltageValue(state.twentyFirst.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                  ],
                ),
              );
            },
          ),
          //
          BlocSelector<BatteryDataCubit, BatteryDataState,
              BatteryLowVoltageTwentyTwoToTwentyFour>(
            selector: (state) => state.lowVoltageTwentyTwoToTwentyFour,
            builder: (context, state) {
              return SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(22),
                      trailing: context.l10n
                          .voltageValue(state.twentySecond.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(23),
                      trailing: context.l10n
                          .voltageValue(state.twentyThird.toStringAsFixed(3)),
                      status: PeriodicValueStatus.normal,
                    ),
                    ChargingScreenListTile(
                      title: context.l10n.cellNTileTitle(24),
                      trailing: context.l10n
                          .voltageValue(state.twentyFourth.toStringAsFixed(3)),
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
