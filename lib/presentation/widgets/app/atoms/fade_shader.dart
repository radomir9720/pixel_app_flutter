import 'package:flutter/material.dart';

@immutable
class EnableFadeSideState {
  const EnableFadeSideState({
    required this.enableStart,
    required this.enableEnd,
  });

  final bool enableStart;
  final bool enableEnd;

  bool get bothDisabled => !enableStart && !enableEnd;

  EnableFadeSideState copyWith({
    bool? enableStart,
    bool? enableEnd,
  }) {
    return EnableFadeSideState(
      enableStart: enableStart ?? this.enableStart,
      enableEnd: enableEnd ?? this.enableEnd,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EnableFadeSideState &&
        other.enableStart == enableStart &&
        other.enableEnd == enableEnd;
  }

  @override
  int get hashCode => enableStart.hashCode ^ enableEnd.hashCode;
}

class EnableFadeSideChangeNotifier extends ValueNotifier<EnableFadeSideState> {
  EnableFadeSideChangeNotifier(super.value);

  void update({
    bool? enableStart,
    bool? enableEnd,
  }) {
    value = value.copyWith(enableStart: enableStart, enableEnd: enableEnd);
  }
}

class FadeShader extends StatelessWidget {
  const FadeShader({
    super.key,
    required this.child,
    this.shadeDimensionFactor = kDefaultShadeDimensionFactor,
    required this.axis,
    required this.enableFadeSideChangeNotifier,
  });

  factory FadeShader.vertical({
    Key? key,
    required Widget child,
    required EnableFadeSideChangeNotifier enableFadeSideChangeNotifier,
    double shadeDimensionFactor = kDefaultShadeDimensionFactor,
  }) =>
      FadeShader(
        key: key,
        enableFadeSideChangeNotifier: enableFadeSideChangeNotifier,
        shadeDimensionFactor: shadeDimensionFactor,
        axis: Axis.vertical,
        child: child,
      );

  factory FadeShader.horizontal({
    Key? key,
    required Widget child,
    required EnableFadeSideChangeNotifier enableFadeSideChangeNotifier,
    double shadeDimensionFactor = kDefaultShadeDimensionFactor,
  }) =>
      FadeShader(
        key: key,
        enableFadeSideChangeNotifier: enableFadeSideChangeNotifier,
        shadeDimensionFactor: shadeDimensionFactor,
        axis: Axis.horizontal,
        child: child,
      );

  static const kDefaultShadeDimensionFactor = .05;

  @protected
  final Widget child;

  @protected
  final double shadeDimensionFactor;

  @protected
  final EnableFadeSideChangeNotifier enableFadeSideChangeNotifier;

  @protected
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EnableFadeSideState>(
      valueListenable: enableFadeSideChangeNotifier,
      builder: (context, state, child) {
        return state.bothDisabled
            ? const SizedBox.shrink()
            : ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: axis == Axis.vertical
                        ? Alignment.topCenter
                        : Alignment.centerLeft,
                    end: axis == Axis.vertical
                        ? Alignment.bottomCenter
                        : Alignment.centerRight,
                    stops: [
                      if (state.enableStart) .0,
                      shadeDimensionFactor,
                      1 - shadeDimensionFactor,
                      if (state.enableEnd) 1,
                    ],
                    colors: [
                      if (state.enableStart) Colors.transparent,
                      Colors.black,
                      Colors.black,
                      if (state.enableEnd) Colors.transparent,
                    ],
                  ).createShader(Offset.zero & Size(rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: child,
              );
      },
      child: child,
    );
  }
}
