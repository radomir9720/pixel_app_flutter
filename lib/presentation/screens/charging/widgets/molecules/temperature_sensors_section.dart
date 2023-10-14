import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/atoms/charging_screen_cell_widget.dart';

class TemperatureSensorsSection extends StatelessWidget {
  const TemperatureSensorsSection({super.key});

  static List<int Function(BatteryDataState state)> selectors = [
    (state) => state.temperatureFirstBatch.first,
    (state) => state.temperatureFirstBatch.second,
    (state) => state.temperatureFirstBatch.third,
    (state) => state.temperatureFirstBatch.fourth,
    (state) => state.temperatureFirstBatch.fifth,
    //
    (state) => state.temperatureSecondBatch.sixth,
    (state) => state.temperatureSecondBatch.seventh,
    (state) => state.temperatureSecondBatch.eighth,
    (state) => state.temperatureSecondBatch.ninth,
    (state) => state.temperatureSecondBatch.tenth,
    (state) => state.temperatureSecondBatch.eleventh,
    (state) => state.temperatureSecondBatch.twelfth,
    //
    (state) => state.temperatureThirdBatch.thirteenth,
    (state) => state.temperatureThirdBatch.fourteenth,
    (state) => state.temperatureThirdBatch.fifteenth,
    (state) => state.temperatureThirdBatch.sixteenth,
    (state) => state.temperatureThirdBatch.seventeenth,
    (state) => state.temperatureThirdBatch.eighteenth,
    (state) => state.temperatureThirdBatch.nineteenth,
  ];

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      itemCount: selectors.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 70,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (context, index) {
        return BlocSelector<BatteryDataCubit, BatteryDataState, int>(
          selector: selectors[index],
          builder: (context, state) {
            return ChargingScreenCellWidget(
              number: index + 1,
              content: context.l10n.celsiusValue(state),
            );
          },
        );
      },
    );
  }
}
