import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

class MiniProgreesIndicator extends StatelessWidget {
  const MiniProgreesIndicator({
    super.key,
    this.primary = true,
  });

  const MiniProgreesIndicator.onPrimary({super.key}) : primary = false;

  @protected
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 15,
      child: CircularProgressIndicator(
        valueColor:
            primary ? null : AlwaysStoppedAnimation(context.colors.onPrimary),
        strokeWidth: 2,
      ),
    );
  }
}
