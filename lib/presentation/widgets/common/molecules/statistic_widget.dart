import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
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
      BlocSelector<DataSourceLiveCubit, DataSourceLiveState, int>(
        selector: (state) => state.battery,
        builder: (context, state) {
          return StatisticItem(
            icon: PixelIcons.battery,
            value: '$state%',
          );
        },
      ),
      StatisticItem(
        icon: PixelIcons.speedometer,
        value: context.l10n.km(128001),
        measurementUnit: context.l10n.kmMeasurementUnit,
      ),
      BlocSelector<DataSourceLiveCubit, DataSourceLiveState, int>(
        selector: (state) => state.sunCharging,
        builder: (context, state) {
          return StatisticItem(
            icon: PixelIcons.sunCharging,
            value: '$state',
            measurementUnit: context.l10n.kwPerHourMeasurementUnit,
          );
        },
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
