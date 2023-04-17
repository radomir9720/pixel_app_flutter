import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/blocs/battery_data_cubit.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/charging_screen_list_tile.dart';

class GeneralInfoTab extends StatelessWidget {
  const GeneralInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocSelector<BatteryDataCubit, BatteryDataState, HighVoltage>(
          selector: (state) => state.highVoltage,
          builder: (context, highVoltage) {
            return ChargingScreenListTile(
              title: context.l10n.totalVoltageTileTitle,
              trailing: context.l10n.voltageValue(
                highVoltage.value.toStringAsFixed(2),
              ),
              status: highVoltage.status,
            );
          },
        ),
        BlocSelector<BatteryDataCubit, BatteryDataState, HighCurrent>(
          selector: (state) => state.highCurrent,
          builder: (context, highCurrent) {
            return ChargingScreenListTile(
              title: context.l10n.totalCurrentTileTitle,
              trailing: context.l10n.currentValue(
                highCurrent.value.toStringAsFixed(2),
              ),
              status: highCurrent.status,
            );
          },
        ),
        BlocSelector<BatteryDataCubit, BatteryDataState, MaxTemperature>(
          selector: (state) => state.maxTemperature,
          builder: (context, maxTemperature) {
            return ChargingScreenListTile(
              title: context.l10n.maximumRegisteredTemperatureTileTitle,
              trailing: context.l10n.celsiusValue(maxTemperature.value),
              status: maxTemperature.status,
            );
          },
        ),
      ],
    );
  }
}
