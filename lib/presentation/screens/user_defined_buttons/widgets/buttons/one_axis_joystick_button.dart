import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_builder.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_axis_update_period_millis_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_outgoing_packages_input_fields.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_title_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/button_decoration_wrapper.dart';

class YAxisJoystickButton
    extends OneAxisJoystickButton<YAxisJoystickUserDefinedButton> {
  const YAxisJoystickButton(super.button, {super.key})
      : super(axis: Axis.vertical);

  static ButtonBuilder<YAxisJoystickUserDefinedButton> builder = ButtonBuilder(
    fields: OneAxisJoystickButton.fields,
    builder: (manager) {
      return YAxisJoystickUserDefinedButton(
        id: DateTime.now().millisecondsSinceEpoch,
        title: manager.getTitle,
        onTap: manager.getOnTap,
        onAxisMove: manager.getOnAxisMove,
        axisUpdatePeriodMillis: manager.getAxisUpdatePeriodMillis,
      );
    },
  );
}

class XAxisJoystickButton
    extends OneAxisJoystickButton<XAxisJoystickUserDefinedButton> {
  const XAxisJoystickButton(super.button, {super.key})
      : super(axis: Axis.horizontal);

  static ButtonBuilder<XAxisJoystickUserDefinedButton> builder = ButtonBuilder(
    fields: OneAxisJoystickButton.fields,
    builder: (manager) {
      return XAxisJoystickUserDefinedButton(
        id: DateTime.now().millisecondsSinceEpoch,
        title: manager.getTitle,
        onTap: manager.getOnTap,
        onAxisMove: manager.getOnAxisMove,
        axisUpdatePeriodMillis: manager.getAxisUpdatePeriodMillis,
      );
    },
  );
}

class OneAxisJoystickButton<T extends OneAxisJoystickUserDefinedButton>
    extends StatefulWidget {
  const OneAxisJoystickButton(this.button, {super.key, required this.axis});

  @protected
  final T button;

  @protected
  final Axis axis;

  @protected
  static List<ButtonPropertyInputField<dynamic>> get fields => [
        ButtonTitleInputField(),
        ButtonAxisUpdatePeriodMillisInputField(),
        AxisUpdateOutgoingPackagesInputFields(),
        TapOutgoingPackagesInputFields(),
      ];

  @override
  State<OneAxisJoystickButton> createState() => _OneAxisJoystickButtonState();
}

extension on Axis {
  bool get isVertical => this == Axis.vertical;
}

class _OneAxisJoystickButtonState extends State<OneAxisJoystickButton>
    with SingleTickerProviderStateMixin {
  late final OneAxisValueNotifier oneAxisNotifier;
  late final PeriodicOutgoungPackagesSender packagesSender;

  @override
  void initState() {
    super.initState();
    packagesSender = PeriodicOutgoungPackagesSender(
      sendCallback: (packages) {
        for (final package in packages) {
          context.read<OutgoingPackagesCubit>().sendPackage(package);
        }
      },
      sendPeriod: Duration(milliseconds: widget.button.axisUpdatePeriodMillis),
    );
    oneAxisNotifier = OneAxisValueNotifier(
      vsync: this,
      onPan: (value) {
        packagesSender.setPackages([
          for (final package in widget.button.onAxisMove)
            DataSourceOutgoingPackage.raw(
              requestType: package.requestType,
              parameterId: package.parameterId,
              data: [(value * 100).toInt()],
            )
        ]);
      },
    );
  }

  @override
  void dispose() {
    oneAxisNotifier.dispose();
    packagesSender.dispose();
    super.dispose();
  }

  @protected
  static const kArrowIconPadding = 10.0;

  @protected
  static const kMainAxisSize = 100.0;

  @protected
  static const kCrossAxisSize = 30.0;

  @override
  Widget build(BuildContext context) {
    final axis = widget.axis;
    final isVertical = axis.isVertical;

    return ButtonDecorationWrapper(
      buttonId: widget.button.id,
      child: Row(
        children: [
          _ButtonTitle(title: widget.button.title),
          SizedBox(
            height: isVertical ? kMainAxisSize : null,
            width: isVertical ? kCrossAxisSize : kMainAxisSize,
            child: LayoutBuilder(
              builder: (context, constraints) {
                oneAxisNotifier.setMaxDistance(kMainAxisSize);
                return ValueListenableBuilder<OneAxisValue>(
                  valueListenable: oneAxisNotifier,
                  builder: (context, value, child) {
                    final factor = value.factor;
                    final xAlignment = isVertical ? 0.0 : factor;
                    final yAlignment = isVertical ? factor : 0.0;
                    return Stack(
                      alignment: Alignment(xAlignment, yAlignment),
                      children: [
                        Positioned.fill(
                          top: isVertical ? kArrowIconPadding : 0,
                          right: isVertical ? 0 : null,
                          bottom: isVertical ? null : 0,
                          child: Center(
                            child: Icon(
                              isVertical
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_left_rounded,
                              color: context.colors.disabled,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          bottom: isVertical ? kArrowIconPadding : 0,
                          left: isVertical ? 0 : null,
                          top: isVertical ? null : 0,
                          child: Center(
                            child: Icon(
                              isVertical
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_right_rounded,
                              color: context.colors.disabled,
                            ),
                          ),
                        ),
                        child ?? const SizedBox.shrink(),
                      ],
                    );
                  },
                  child: GestureDetector(
                    onVerticalDragStart: !isVertical
                        ? null
                        : (details) {
                            packagesSender.startSending();
                          },
                    onVerticalDragUpdate: !isVertical
                        ? null
                        : (details) {
                            oneAxisNotifier
                                .updateCurrentPosition(details.delta.dy);
                          },
                    onVerticalDragEnd: !isVertical
                        ? null
                        : (details) {
                            packagesSender.stopSending();
                            oneAxisNotifier.moveAnimated();
                          },
                    onHorizontalDragStart: isVertical
                        ? null
                        : (details) {
                            packagesSender.startSending();
                          },
                    onHorizontalDragUpdate: isVertical
                        ? null
                        : (details) {
                            oneAxisNotifier.updateCurrentPosition(
                              isVertical ? details.delta.dy : details.delta.dx,
                            );
                          },
                    onHorizontalDragEnd: isVertical
                        ? null
                        : (details) {
                            packagesSender.stopSending();
                            oneAxisNotifier.moveAnimated();
                          },
                    onTap: () {
                      for (final package in widget.button.onTap) {
                        context.read<OutgoingPackagesCubit>().sendPackage(
                              DataSourceOutgoingPackage.raw(
                                requestType: package.requestType,
                                parameterId: package.parameterId,
                                data: package.data,
                              ),
                            );
                      }
                    },
                    child: SizedBox.square(
                      dimension: 30,
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
                );
              },
            ),
          ),
          // VerticalDivider(width: 6),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class _ButtonTitle extends StatelessWidget {
  const _ButtonTitle({required this.title});

  @protected
  final String title;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          title,
          textAlign: TextAlign.center,
          overflow: TextOverflow.fade,
        ),
      ),
    );
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

class OneAxisValueNotifier extends ValueNotifier<OneAxisValue> {
  OneAxisValueNotifier({
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
      value = value.copyWith(
        factor: newFactor,
        currentPosition: value.maxDistance * ((value.factor + 1) / 2),
      );
    }

    try {
      animationController
        ..stop()
        ..reset()
        ..addListener(_animationListener);

      await animationController.forward();
    } finally {
      animationController
        ..stop()
        ..removeListener(_animationListener)
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

class PeriodicOutgoungPackagesSender {
  PeriodicOutgoungPackagesSender({
    required this.sendPeriod,
    required this.sendCallback,
  }) : packages = [];

  @visibleForTesting
  final List<DataSourceOutgoingPackage> packages;

  @protected
  final Duration sendPeriod;

  @protected
  final void Function(List<DataSourceOutgoingPackage> packages) sendCallback;

  @visibleForTesting
  Timer? timer;

  void setPackages(List<DataSourceOutgoingPackage> packages) {
    this.packages
      ..clear()
      ..addAll(packages);
  }

  void startSending() {
    _cancel();
    timer = Timer.periodic(
      sendPeriod,
      (timer) => sendCallback(packages),
    );
  }

  void stopSending() {
    sendCallback(packages);
    _cancel();
  }

  void _cancel() {
    timer?.cancel();
    timer = null;
  }

  void dispose() {
    _cancel();
  }
}
