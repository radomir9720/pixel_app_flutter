import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/app/extensions.dart';
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
      BlocSelector<GeneralDataCubit, GeneralDataState, Uint8WithStatusBody>(
        selector: (state) => state.batteryLevel,
        builder: (context, state) {
          return StatisticItem(
            icon: PixelIcons.battery,
            value: '${state.value}%',
            customColor: context.colorFromStatus(state.status),
          );
        },
      ),
      BlocSelector<GeneralDataCubit, GeneralDataState, Uint32WithStatusBody>(
        selector: (state) => state.odometer,
        builder: (context, state) {
          final km = state.value ~/ 10;
          return StatisticItem(
            icon: PixelIcons.speedometer,
            value: context.l10n.km(km),
            measurementUnit: context.l10n.kmMeasurementUnit,
            customColor: context.colorFromStatus(state.status),
          );
        },
      ),
      BlocSelector<GeneralDataCubit, GeneralDataState, Int16WithStatusBody>(
        selector: (state) => state.power,
        builder: (context, state) {
          final value = state.value;
          return StatisticItem(
            icon: value < 1 ? PixelIcons.batteryMinus : PixelIcons.batteryPlus,
            value: '${value.abs()}',
            measurementUnit: 'Вт',
            customColor: context.colorFromStatus(
              state.status,
              onNormal: () {
                return value > 0 ? context.colors.successPastel : null;
              },
            ),
          );
        },
      )
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
