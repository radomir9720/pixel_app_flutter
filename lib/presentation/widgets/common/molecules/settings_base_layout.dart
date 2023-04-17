import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/close_button.dart';

class SettingsBaseLayout extends StatelessWidget {
  const SettingsBaseLayout({
    super.key,
    required this.screenTitle,
    required this.buttons,
    this.bottom = const SizedBox.shrink(),
    this.showBottom = true,
    this.bottomLeft,
  });

  @protected
  final String screenTitle;

  @protected
  final List<Widget> buttons;

  @protected
  final Widget bottom;

  @protected
  final bool showBottom;

  @protected
  final Widget? bottomLeft;

  @override
  Widget build(BuildContext context) {
    final screenData = Screen.of(context);
    final bodyPadding = screenData.whenType(
      handset: () => const EdgeInsets.symmetric(horizontal: 16),
      orElse: () => EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * .07,
      ),
    );
    final closeButtonPadding = screenData.whenType(
      handset: () => const EdgeInsets.all(16),
      orElse: () => const EdgeInsets.symmetric(
        horizontal: 38,
        vertical: 33,
      ),
    );
    final buttonFontSize = screenData.whenType(
      handset: () => 14.0,
      orElse: () => 16.0,
    );

    final height = MediaQuery.of(context).size.height;
    const standardScreenHeight = 700;

    final factor = (1 - (height / standardScreenHeight).clamp(1, 1.5)).abs();
    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: (factor * standardScreenHeight + 32)
                .clamp(0, height / 4)
                .toDouble(),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                screenTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Divider(
            indent: bodyPadding.left,
            endIndent: bodyPadding.right,
          ),
          const SizedBox(height: 32),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: bodyPadding,
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: buttons
                      .map(
                        (e) => ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 60,
                            maxWidth: math.min(
                              MediaQuery.of(context).size.width / 2.4,
                              250,
                            ),
                          ),
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: DefaultTextStyle(
                              style: TextStyle(
                                fontSize: buttonFontSize,
                              ),
                              child: e,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          if (showBottom)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: closeButtonPadding,
                    child: bottomLeft ?? const PCloseButton(),
                  ),
                ),
                Expanded(
                  child: Center(child: bottom),
                ),
                const Spacer(),
              ],
            ),
        ],
      ),
    );
  }
}
