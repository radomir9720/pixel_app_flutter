import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/widgets/atoms/charging_screen_cell_widget.dart';

class VoltageCellsSection extends StatelessWidget {
  const VoltageCellsSection({super.key});

  static List<double Function(BatteryDataState state)> selectors = [
    (state) => state.lowVoltageOneToThree.first,
    (state) => state.lowVoltageOneToThree.second,
    (state) => state.lowVoltageOneToThree.third,
    //
    (state) => state.lowVoltageFourToSix.fourth,
    (state) => state.lowVoltageFourToSix.fifth,
    (state) => state.lowVoltageFourToSix.sixth,
    //
    (state) => state.lowVoltageSevenToNine.seventh,
    (state) => state.lowVoltageSevenToNine.eighth,
    (state) => state.lowVoltageSevenToNine.ninth,
    //
    (state) => state.lowVoltageTenToTwelve.tenth,
    (state) => state.lowVoltageTenToTwelve.eleventh,
    (state) => state.lowVoltageTenToTwelve.twelfth,
    //
    (state) => state.lowVoltageThirteenToFifteen.thirteenth,
    (state) => state.lowVoltageThirteenToFifteen.fourteenth,
    (state) => state.lowVoltageThirteenToFifteen.fifteenth,
    //
    (state) => state.lowVoltageSixteenToEighteen.sixteenth,
    (state) => state.lowVoltageSixteenToEighteen.seventeenth,
    (state) => state.lowVoltageSixteenToEighteen.eighteenth,
    //
    (state) => state.lowVoltageNineteenToTwentyOne.nineteenth,
    (state) => state.lowVoltageNineteenToTwentyOne.twentieth,
    (state) => state.lowVoltageNineteenToTwentyOne.twentyFirst,
    //
    (state) => state.lowVoltageTwentyTwoToTwentyFour.twentySecond,
    (state) => state.lowVoltageTwentyTwoToTwentyFour.twentyThird,
    (state) => state.lowVoltageTwentyTwoToTwentyFour.twentyFourth,
    //
    (state) => state.lowVoltageTwentyFiveToTwentySeven.twentyFifth,
    (state) => state.lowVoltageTwentyFiveToTwentySeven.twentySixth,
    (state) => state.lowVoltageTwentyFiveToTwentySeven.twentySeventh,
    //
    (state) => state.lowVoltageTwentyEightToThirty.twentyEighth,
    (state) => state.lowVoltageTwentyEightToThirty.twentyNinth,
    (state) => state.lowVoltageTwentyEightToThirty.thirtieth,
    //
    (state) => state.lowVoltageThirtyOneToThirtyThree.thirtyFirst,
    (state) => state.lowVoltageThirtyOneToThirtyThree.thirtySecond,
    (state) => state.lowVoltageThirtyOneToThirtyThree.thirtyThird,
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
        return BlocSelector<BatteryDataCubit, BatteryDataState, double>(
          selector: selectors[index],
          builder: (context, state) {
            return ChargingScreenCellWidget(
              number: index + 1,
              content: context.l10n.voltageValue(state.toStringAsFixed(3)),
            );
          },
        );
      },
    );
  }
}
