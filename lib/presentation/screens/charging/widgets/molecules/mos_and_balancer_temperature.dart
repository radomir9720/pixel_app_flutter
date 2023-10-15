import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/atoms/charging_screen_list_tile.dart';

class MOSAndBalancerTemperature extends StatelessWidget {
  const MOSAndBalancerTemperature({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<BatteryDataCubit, BatteryDataState,
        BatteryTemperatureFirstBatch>(
      selector: (state) => state.temperatureFirstBatch,
      builder: (context, state) {
        return SliverList.list(
          children: [
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
          ],
        );
      },
    );
  }
}
