import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/statistic_item.dart';

class StatisticWidget extends StatelessWidget {
  const StatisticWidget({super.key, this.useWrap = false});

  @protected
  final bool useWrap;

  @override
  Widget build(BuildContext context) {
    final items = [
      const StatisticItem(
        icon: PixelIcons.battery,
        value: '80%',
      ),
      StatisticItem(
        icon: PixelIcons.speedometer,
        value: context.l10n.km(128001),
        measurementUnit: context.l10n.kmMeasurementUnit,
      ),
      StatisticItem(
        icon: PixelIcons.sunCharging,
        value: '340',
        measurementUnit: context.l10n.kwPerHourMeasurementUnit,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.statisticInfoPanelTitle,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 16),
          if (useWrap)
            Wrap(
              runSpacing: 16,
              spacing: 85,
              children: items,
            )
          else
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: items,
              ),
            ),
        ],
      ),
    );
  }
}
