import 'package:flutter/material.dart';

enum FadeSide {
  left,
  top,
  right,
  bottom;

  R when<R>({
    required R Function() left,
    required R Function() top,
    required R Function() right,
    required R Function() bottom,
  }) {
    switch (this) {
      case FadeSide.left:
        return left();
      case FadeSide.top:
        return top();
      case FadeSide.right:
        return right();
      case FadeSide.bottom:
        return bottom();
    }
  }
}

class FadeShader extends StatelessWidget {
  const FadeShader({
    super.key,
    required this.child,
    required this.side,
    required this.enable,
    this.dimension = 16,
  });

  @protected
  final Widget child;

  @protected
  final FadeSide side;

  @protected
  final double dimension;

  @protected
  final ValueNotifier<bool> enable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: enable,
      builder: (context, enable, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            if (!enable) {
              return const LinearGradient(colors: [Colors.black, Colors.black])
                  .createShader(Rect.zero);
            }

            return LinearGradient(
              begin: side.when(
                left: () => Alignment.centerRight,
                top: () => Alignment.topCenter,
                right: () => Alignment.centerRight,
                bottom: () => Alignment.topCenter,
              ),
              end: side.when(
                left: () => Alignment.centerLeft,
                top: () => Alignment.bottomCenter,
                right: () => Alignment.centerLeft,
                bottom: () => Alignment.bottomCenter,
              ),
              colors: side.when(
                left: () => [
                  Colors.black,
                  Colors.transparent,
                ],
                top: () => [
                  Colors.transparent,
                  Colors.black,
                ],
                right: () => [
                  Colors.transparent,
                  Colors.black,
                ],
                bottom: () => [
                  Colors.black,
                  Colors.transparent,
                ],
              ),
            ).createShader(
              side.when(
                left: () => Offset.zero & Size(dimension, rect.height),
                top: () => Offset.zero & Size(rect.width, dimension),
                right: () =>
                    Offset(rect.width - dimension, 0) &
                    Size(dimension, rect.height),
                bottom: () =>
                    Offset(0, rect.height - dimension) &
                    Size(rect.width, dimension),
              ),
            );
          },
          blendMode: BlendMode.dstIn,
          child: child,
        );
      },
      child: child,
    );
  }
}
