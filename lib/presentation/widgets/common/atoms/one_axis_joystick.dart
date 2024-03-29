import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';

extension on Axis {
  bool get isVertical => this == Axis.vertical;
}

class OneAxisJoystick extends StatefulWidget {
  const OneAxisJoystick({
    super.key,
    required this.axis,
    required this.controller,
    required this.notifier,
    this.mainAxisSize = 100,
    this.crossAxisSize = 30,
    this.arrowIconPadding = 10,
    this.thumbSize = 30,
    this.iconSize = 24,
  });

  @protected
  final Axis axis;

  @protected
  final double mainAxisSize;

  @protected
  final double crossAxisSize;

  @protected
  final double arrowIconPadding;

  @protected
  final OneAxisJoystickController controller;

  @protected
  final OneAxisJoystickNotifier notifier;

  @protected
  final double thumbSize;

  @protected
  final double iconSize;

  @override
  State<OneAxisJoystick> createState() => _OneAxisJoystickState();
}

class _OneAxisJoystickState extends State<OneAxisJoystick> {
  final thumbKey = GlobalKey();
  bool pointerDown = false;

  void onPanUpdate(DragUpdateDetails details) {
    final delta = widget.axis.isVertical ? -details.delta.dy : details.delta.dx;
    widget.controller.onDragUpdate(delta);
    widget.notifier.updateCurrentPosition(delta);
  }

  void onCancel([Axis? axis]) {
    if (axis != null && axis != widget.axis) return;
    widget.controller.onDragEnd();
    widget.notifier.moveAnimated();
  }

  void onStart([Axis? axis]) {
    if (axis != null && axis != widget.axis) return;
    widget.controller.onDragStart();
  }

  @override
  Widget build(BuildContext context) {
    final axis = widget.axis;
    final isVertical = axis.isVertical;

    return Listener(
      onPointerUp: (_) => widget.controller.onPointerUp(),
      onPointerDown: (_) => widget.controller.onPointerDown(),
      child: GestureDetector(
        onPanDown: (details) {
          final tapOffset = details.globalPosition;
          final renderBox =
              thumbKey.currentContext?.findRenderObject() as RenderBox?;

          if (renderBox == null) return;
          final size = renderBox.size;

          final buttonTopRightOffset = renderBox.localToGlobal(Offset.zero);
          final buttonCenter =
              buttonTopRightOffset + Offset(size.width / 2, size.height / 2);

          final buttonRect = Rect.fromCenter(
            center: buttonCenter,
            width: widget.thumbSize,
            height: widget.thumbSize,
          );

          final isTapOnButton = buttonRect.contains(tapOffset);

          if (isTapOnButton) return;
          final offsetDelta = tapOffset - buttonCenter;
          final delta = isVertical ? -offsetDelta.dy : offsetDelta.dx;
          widget.notifier.updateCurrentPosition(delta);
        },
        onTapUp: (_) => onCancel(),
        onPanStart: (_) => onStart(),
        onPanUpdate: onPanUpdate,
        onLongPressStart: (_) => onStart(),
        onLongPressMoveUpdate: (details) {
          final currentPosition = widget.axis.isVertical
              ? widget.mainAxisSize - widget.notifier.value.currentPosition
              : widget.notifier.value.currentPosition;
          final delta = widget.axis.isVertical
              ? currentPosition - details.localPosition.dy
              : details.localPosition.dx - currentPosition;
          widget.controller.onDragUpdate(delta);
          widget.notifier.updateCurrentPosition(delta);
        },
        onPanEnd: (_) => onCancel(),
        onLongPressEnd: (_) => onCancel(),
        child: ColoredBox(
          color: Colors.transparent,
          child: SizedBox(
            height: isVertical ? widget.mainAxisSize : null,
            width: isVertical ? widget.crossAxisSize : widget.mainAxisSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                widget.notifier.setMaxDistance(widget.mainAxisSize);
                return ValueListenableBuilder<OneAxisValue>(
                  valueListenable: widget.notifier,
                  builder: (context, value, child) {
                    final factor = value.factor;
                    final xAlignment = isVertical ? 0.0 : factor;
                    final yAlignment = isVertical ? factor : 0.0;
                    return Stack(
                      alignment: Alignment(xAlignment, -yAlignment),
                      children: [
                        Positioned.fill(
                          top: isVertical ? widget.arrowIconPadding : 0,
                          right: isVertical ? 0 : null,
                          bottom: isVertical ? null : 0,
                          child: Center(
                            child: Icon(
                              isVertical
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_left_rounded,
                              size: widget.iconSize,
                              color: context.colors.disabled,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          bottom: isVertical ? widget.arrowIconPadding : 0,
                          left: isVertical ? 0 : null,
                          top: isVertical ? null : 0,
                          child: Center(
                            child: Icon(
                              isVertical
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_right_rounded,
                              size: widget.iconSize,
                              color: context.colors.disabled,
                            ),
                          ),
                        ),
                        child ?? const SizedBox.shrink(),
                      ],
                    );
                  },
                  child: GestureDetector(
                    key: thumbKey,
                    onVerticalDragStart: (_) => onStart(Axis.vertical),
                    onVerticalDragUpdate: onPanUpdate,
                    onVerticalDragEnd: (_) => onCancel(Axis.vertical),
                    onHorizontalDragStart: (_) => onStart(Axis.horizontal),
                    onHorizontalDragUpdate: onPanUpdate,
                    onHorizontalDragEnd: (_) => onCancel(Axis.horizontal),
                    onTap: widget.controller.onTap,
                    child: SizedBox.square(
                      dimension: widget.thumbSize,
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.disabled,
                            border: Border.all(color: Colors.black26),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 3,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

abstract class OneAxisJoystickController {
  const OneAxisJoystickController();

  void onDragEnd();

  void onPointerDown();

  void onPointerUp();

  void onDragUpdate(double delta);

  void onDragStart();

  void onTap();
}

final class OneAxisJoystickControllerWrapper
    implements OneAxisJoystickController {
  const OneAxisJoystickControllerWrapper({
    required this.onDragEndCallback,
    required this.onDragStartCallback,
    required this.onDragUpdateCallback,
    required this.onTapCallback,
    required this.onPointerDownCallback,
    required this.onPointerUpCallback,
  });

  @protected
  final void Function() onDragEndCallback;

  @protected
  final void Function() onDragStartCallback;

  @protected
  final void Function(double delta) onDragUpdateCallback;

  @protected
  final void Function() onTapCallback;

  @protected
  final void Function() onPointerDownCallback;

  @protected
  final void Function() onPointerUpCallback;

  @override
  void onDragEnd() => onDragEndCallback();

  @override
  void onDragStart() => onDragStartCallback();

  @override
  void onDragUpdate(double delta) => onDragUpdateCallback(delta);

  @override
  void onTap() => onTapCallback();

  @override
  void onPointerDown() => onPointerDownCallback();

  @override
  void onPointerUp() => onPointerUpCallback();
}

class OneAxisJoystickNotifier extends ValueNotifier<OneAxisValue> {
  OneAxisJoystickNotifier({
    required TickerProvider vsync,
    required this.onPan,
    Duration animationDuration = const Duration(milliseconds: 150),
    OneAxisValue initialValue = const OneAxisValue.initial(),
  })  : animationController = AnimationController(
          vsync: vsync,
          duration: animationDuration,
        ),
        super(initialValue);

  @visibleForTesting
  final AnimationController animationController;

  @protected
  final ValueSetter<double> onPan;

  void setMaxDistance(double maxDistance) {
    if (value.maxDistance == maxDistance) return;
    final currentPosition = maxDistance * ((value.factor + 1) / 2);
    value = value.copyWith(
      maxDistance: maxDistance,
      currentPosition: currentPosition,
    );
  }

  void updateCurrentPosition(double operand) {
    final newPosition =
        (value.currentPosition + operand).clamp(0.0, value.maxDistance);
    final newFactor = newPosition / value.maxDistance * 2 - 1;
    onPan(newFactor);
    value = value.copyWith(
      currentPosition: newPosition,
      factor: newFactor,
    );
  }

  Future<void> moveAnimated({double factor = 0}) async {
    final startFactor = value.factor;

    void _animationListener() {
      final diff = factor - startFactor;
      final progress = animationController.value * diff;
      final newFactor = startFactor + progress;
      final newPosition = value.maxDistance * ((value.factor + 1) / 2);
      value = value.copyWith(
        factor: newFactor,
        currentPosition: newPosition,
      );
    }

    try {
      animationController
        ..stop()
        // ignore: invalid_use_of_protected_member
        ..clearListeners()
        ..reset()
        ..addListener(_animationListener);

      await animationController.forward();
    } finally {
      animationController
        ..stop()
        // ignore: invalid_use_of_protected_member
        ..clearListeners()
        ..reset();
    }
  }

  @override
  void dispose() {
    animationController
      ..stop()
      ..dispose();
    super.dispose();
  }
}

@immutable
final class OneAxisValue {
  const OneAxisValue({
    required this.factor,
    required this.maxDistance,
    required this.currentPosition,
  });

  const OneAxisValue.initial()
      : factor = 0,
        maxDistance = 0,
        currentPosition = 0;

  final double maxDistance;
  final double factor;
  final double currentPosition;

  OneAxisValue copyWith({
    double? maxDistance,
    double? factor,
    double? currentPosition,
  }) {
    return OneAxisValue(
      maxDistance: maxDistance ?? this.maxDistance,
      factor: factor ?? this.factor,
      currentPosition: currentPosition ?? this.currentPosition,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OneAxisValue &&
        other.maxDistance == maxDistance &&
        other.factor == factor &&
        other.currentPosition == currentPosition;
  }

  @override
  int get hashCode =>
      maxDistance.hashCode ^ factor.hashCode ^ currentPosition.hashCode;
}
