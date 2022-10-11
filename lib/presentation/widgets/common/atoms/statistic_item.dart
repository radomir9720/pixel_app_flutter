import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class StatisticItem extends StatelessWidget {
  const StatisticItem({
    super.key,
    required this.icon,
    required this.value,
    this.measurementUnit,
  });

  @protected
  final IconData icon;

  @protected
  final String value;

  @protected
  final String? measurementUnit;

  @protected
  static const valueTextStyle = TextStyle(
    height: 1.21,
    fontSize: 14,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  @protected
  static const measurementUnitTextStyle = TextStyle(
    height: 1.21,
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w600,
  );

  @override
  Widget build(BuildContext context) {
    final color = AppColors.of(context).textAccent;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(
          width: 13,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$value ',
                style: valueTextStyle.copyWith(color: color),
              ),
              if (measurementUnit != null)
                TextSpan(
                  text: measurementUnit,
                  style: measurementUnitTextStyle.copyWith(color: color),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
