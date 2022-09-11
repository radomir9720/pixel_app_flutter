import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:re_seedwork/re_seedwork.dart';

class FanIndicator extends StatelessWidget {
  const FanIndicator({super.key, required this.power, this.sections = 5})
      : assert(
          power >= 0 && power <= sections,
          'power should be more or equal than 0 and '
          'less or equal than sections',
        );

  @protected
  final int power;

  @protected
  final int sections;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          sections,
          (index) {
            final disabled = power < index + 1;

            return SizedBox.square(
              dimension: 6,
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  shape: const CircleBorder().copyWith(
                    side: disabled
                        ? BorderSide(color: AppColors.of(context).disabled)
                        : null,
                  ),
                  color: disabled ? null : AppColors.of(context).primary,
                ),
              ),
            );
          },
        ).divideBy(const SizedBox(width: 3)).toList(),
      ),
    );
  }
}
