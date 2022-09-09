import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class AppTypography extends StatelessWidget {
  @literal
  const AppTypography({
    required this.child,
    super.key,
    this.maxScaleFactor,
  });

  @protected
  final Widget child;

  @protected
  final double? maxScaleFactor;

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = min(
      maxScaleFactor ?? double.infinity,
      window.textScaleFactor,
    );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaleFactor: textScaleFactor,
      ),
      child: InheritedAppTypography(
        textScaleFactor: textScaleFactor,
        child: DefaultTextHeightBehavior(
          textHeightBehavior: const TextHeightBehavior(
            leadingDistribution: TextLeadingDistribution.even,
          ),
          child: child,
        ),
      ),
    );
  }
}

@protected
class InheritedAppTypography extends InheritedWidget {
  @literal
  const InheritedAppTypography({
    required super.child,
    required this.textScaleFactor,
    super.key,
  });

  final double textScaleFactor;

  @override
  bool updateShouldNotify(InheritedAppTypography oldWidget) {
    return textScaleFactor != oldWidget.textScaleFactor;
  }
}
