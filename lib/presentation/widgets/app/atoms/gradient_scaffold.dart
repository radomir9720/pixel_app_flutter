import 'package:flutter/material.dart';

class GradientScaffold extends Scaffold {
  GradientScaffold({
    required Widget body,
    super.bottomNavigationBar,
    super.backgroundColor,
    super.extendBody,
    super.resizeToAvoidBottomInset,
    super.key,
  }) : super(
          body: Builder(
            builder: (context) {
              final colors = ArgumentError.checkNotNull(
                Theme.of(context).extension<GradientScaffoldColors>(),
                'GradientScaffoldColors',
              );

              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colors.start,
                      colors.end,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: body,
                ),
              );
            },
          ),
        );
}

@immutable
class GradientScaffoldColors extends ThemeExtension<GradientScaffoldColors> {
  const GradientScaffoldColors({required this.start, required this.end});

  final Color start;

  final Color end;

  @override
  ThemeExtension<GradientScaffoldColors> copyWith({Color? start, Color? end}) {
    return GradientScaffoldColors(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  ThemeExtension<GradientScaffoldColors> lerp(
    ThemeExtension<GradientScaffoldColors>? other,
    double t,
  ) {
    if (other is! GradientScaffoldColors) {
      return this;
    }

    return GradientScaffoldColors(
      start: Color.lerp(start, other.start, t) ?? Colors.transparent,
      end: Color.lerp(end, other.end, t) ?? Colors.transparent,
    );
  }
}
