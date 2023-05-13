import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/speed_widget.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/statistic_widget.dart';

class TabletUpperInfoPanel extends StatelessWidget {
  const TabletUpperInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          flex: 6,
          child: SpeedWidget(),
        ),
        Expanded(
          flex: 4,
          child: Align(
            child: StatisticWidget(),
          ),
        ),
        // Expanded(
        //   flex: 8,
        //   child: Align(
        //     alignment: Alignment.centerRight,
        //     child: FastActionsWidget.manyRows(),
        //   ),
        // ),
      ],
    );
    // CustomMultiChildLayout(
    //   delegate: CustomLayoutDelegate(),
    //   children: [
    //     LayoutId(
    //       id: LayoutDelegateSlot.speed,
    //       child: const SpeedWidget(),
    //     ),
    //     LayoutId(
    //       id: LayoutDelegateSlot.statistic,
    //       child: const StatisticWidget(),
    //     ),
    //     LayoutId(
    //       id: LayoutDelegateSlot.actions,
    //       child: FastActionsWidget.manyRows(),
    //     ),
    //   ],
    // ),
    // );
  }
}

// enum LayoutDelegateSlot {
//   speed,
//   statistic,
//   actions,
// }

// class CustomLayoutDelegate extends MultiChildLayoutDelegate {
//   @override
//   void performLayout(Size size) {
//     var speedSize = Size.zero;
//     var statisticSize = Size.zero;
//     var actionsSize = Size.zero;

//     final hasStatistic = hasChild(LayoutDelegateSlot.statistic);
//     final hasActions = hasChild(LayoutDelegateSlot.actions);

//     if (hasChild(LayoutDelegateSlot.speed)) {
//       speedSize =
//           layoutChild(LayoutDelegateSlot.speed, BoxConstraints.loose(size));
//       positionChild(LayoutDelegateSlot.speed, Offset.zero);
//     }

//     if (hasStatistic) {
//       statisticSize = layoutChild(
//         LayoutDelegateSlot.statistic,
//         BoxConstraints(maxHeight: speedSize.height),
//       );
//     }

//     if (hasActions) {
//       actionsSize = layoutChild(
//         LayoutDelegateSlot.actions,
//         BoxConstraints(
//           maxHeight: speedSize.height,
//           maxWidth: size.width - speedSize.width - statisticSize.width,
//         ),
//       );
//     }

//     // position
//     if (hasStatistic && hasActions) {
//       final remainingWidth = size.width - speedSize.width;

//       positionChild(
//         LayoutDelegateSlot.actions,
//         Offset(size.width - actionsSize.width, 0),
//       );

//       final spaceForStatistic = remainingWidth - actionsSize.width;

//       final statLeftEdge =
//           speedSize.width + (spaceForStatistic - statisticSize.width) / 2;

//       positionChild(LayoutDelegateSlot.statistic, Offset(statLeftEdge, 0));
//     } else if (hasStatistic) {
//       positionChild(
//         LayoutDelegateSlot.statistic,
//         Offset(size.width - statisticSize.width, 0),
//       );
//     } else if (hasActions) {
//       positionChild(
//         LayoutDelegateSlot.actions,
//         Offset(size.width - actionsSize.width, 0),
//       );
//     }
//   }

//   @override
//   bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
//     return false;
//   }
// }
