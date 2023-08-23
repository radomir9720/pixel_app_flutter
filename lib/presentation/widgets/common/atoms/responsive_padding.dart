import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';

class ResponsivePadding extends StatelessWidget {
  const ResponsivePadding({super.key, required this.child});

  @protected
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);
    final screenType = screenData.type;
    final landscape = !screenType.isHandset || screenData.isLandscape;

    return Padding(
      padding: screenType.isHandset
          ? const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 32,
            ).copyWith(
              left: landscape ? 87 : 16,
            )
          : EdgeInsets.zero,
      child: child,
    );
  }
}
