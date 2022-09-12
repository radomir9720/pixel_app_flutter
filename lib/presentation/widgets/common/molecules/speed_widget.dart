import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';

class SpeedWidget extends StatelessWidget {
  const SpeedWidget({super.key});

  @protected
  static const speedTextStyle = TextStyle(
    height: 0.88,
    fontSize: 104,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  @protected
  static const kmhTextStyle = TextStyle(
    height: 1.21,
    fontSize: 23,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    final isHandset = Screen.of(context).type.isHandset;

    return Padding(
      padding: EdgeInsets.only(right: isHandset ? 0 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.speedInfoPanelTitle,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(
            height: 16,
          ),
          FittedBox(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '160',
                    style: speedTextStyle.copyWith(
                      color: AppColors.of(context).textAccent,
                    ),
                  ),
                  TextSpan(
                    text: context.l10n.kmPerHourMeasurenentUnit,
                    style: kmhTextStyle.copyWith(
                      color: AppColors.of(context).textAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
