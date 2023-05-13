import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/statistic_item.dart';
import 'package:re_seedwork/re_seedwork.dart';

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({super.key, this.useWrap = false});

  @protected
  final bool useWrap;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      // BlocSelector<GeneralDataCubit, GeneralDataState, double>(
      //   selector: (state) => state.voltage,
      //   builder: (context, state) {
      //     return
      const StatisticItem(
        icon: PixelIcons.battery,
        value: '100%',
      ),
      //     ;
      //   },
      // ),
      StatisticItem(
        icon: PixelIcons.speedometer,
        value: context.l10n.km(128001),
        measurementUnit: context.l10n.kmMeasurementUnit,
      ),
      // BlocSelector<GeneralDataCubit, GeneralDataState, double>(
      //   selector: (state) => state.current,
      //   builder: (context, state) {
      //     return
      StatisticItem(
        icon: PixelIcons.sunCharging,
        value: '870',
        measurementUnit: context.l10n.kwPerHourMeasurementUnit,
      ),
      //     ;
      //   },
      // ),
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.statisticInfoPanelTitle,
            style: Theme.of(context).textTheme.headlineMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          if (useWrap)
            Wrap(
              runSpacing: 16,
              spacing: 85,
              children: items
                  .map(
                    (child) => SizedBox(
                      width: 150,
                      child: child,
                    ),
                  )
                  .toList(),
            )
          else
            FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items.divideBy(const SizedBox(height: 10)).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
