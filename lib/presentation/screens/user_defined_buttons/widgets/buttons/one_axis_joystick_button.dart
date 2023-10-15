import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/user_defined_buttons/user_defined_buttons.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_builder.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/button_property_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_axis_update_period_millis_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_outgoing_packages_input_fields.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/models/button_property_input_field/implementations/button_title_input_field.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/button_decoration_wrapper.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/one_axis_joystick.dart';

class YAxisJoystickButton
    extends OneAxisJoystickButton<YAxisJoystickUserDefinedButton> {
  const YAxisJoystickButton(super.button, {super.key})
      : super(axis: Axis.vertical);

  static ButtonBuilder<YAxisJoystickUserDefinedButton> builder([
    YAxisJoystickUserDefinedButton? initialValue,
  ]) {
    return ButtonBuilder(
      fields: OneAxisJoystickButton.fields(initialValue),
      builder: (manager, id) {
        return YAxisJoystickUserDefinedButton(
          id: id,
          title: manager.getTitle,
          onTap: manager.getOnTap,
          onAxisMove: manager.getOnAxisMove,
          axisUpdatePeriodMillis: manager.getAxisUpdatePeriodMillis,
        );
      },
    );
  }
}

class XAxisJoystickButton
    extends OneAxisJoystickButton<XAxisJoystickUserDefinedButton> {
  const XAxisJoystickButton(super.button, {super.key})
      : super(axis: Axis.horizontal);

  static ButtonBuilder<XAxisJoystickUserDefinedButton> builder([
    XAxisJoystickUserDefinedButton? initialValue,
  ]) {
    return ButtonBuilder(
      fields: OneAxisJoystickButton.fields(initialValue),
      builder: (manager, id) {
        return XAxisJoystickUserDefinedButton(
          id: id,
          title: manager.getTitle,
          onTap: manager.getOnTap,
          onAxisMove: manager.getOnAxisMove,
          axisUpdatePeriodMillis: manager.getAxisUpdatePeriodMillis,
        );
      },
    );
  }
}

class OneAxisJoystickButton<T extends OneAxisJoystickUserDefinedButton>
    extends StatefulWidget {
  const OneAxisJoystickButton(this.button, {super.key, required this.axis});

  @protected
  final T button;

  @protected
  final Axis axis;

  @protected
  static List<ButtonPropertyInputField<dynamic>>
      fields<T extends OneAxisJoystickUserDefinedButton>([T? initialValue]) {
    return [
      ButtonTitleInputField(initialValue: initialValue?.title),
      ButtonAxisUpdatePeriodMillisInputField(
        initialValue: initialValue?.axisUpdatePeriodMillis,
      ),
      AxisUpdateOutgoingPackagesInputFields(
        initialPackages: initialValue?.onAxisMove,
      ),
      TapOutgoingPackagesInputFields(initialPackages: initialValue?.onTap),
    ];
  }

  @override
  State<OneAxisJoystickButton> createState() => _OneAxisJoystickButtonState();
}

class _OneAxisJoystickButtonState extends State<OneAxisJoystickButton>
    with SingleTickerProviderStateMixin {
  late final OneAxisJoystickNotifier notifier;
  late final PackageSenderOneAxisJoystickController controller;

  @override
  void initState() {
    super.initState();
    controller = PackageSenderOneAxisJoystickController(
      onTapSend: [
        for (final package in widget.button.onTap)
          DataSourceOutgoingPackage.raw(
            requestType: package.requestType,
            parameterId: package.parameterId,
            data: package.data,
          ),
      ],
      sendCallback: (packages) {
        for (final package in packages) {
          context.read<OutgoingPackagesCubit>().sendPackage(package);
        }
      },
      sendPeriod: Duration(milliseconds: widget.button.axisUpdatePeriodMillis),
    );
    notifier = OneAxisJoystickNotifier(
      vsync: this,
      onPan: (value) {
        controller.setPackages([
          for (final package in widget.button.onAxisMove)
            DataSourceOutgoingPackage.raw(
              requestType: package.requestType,
              parameterId: package.parameterId,
              data: [
                ...package.data,
                (value * 100).toInt(),
              ],
            ),
        ]);
      },
    );
  }

  @override
  void dispose() {
    notifier.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final axis = widget.axis;

    return ButtonDecorationWrapper(
      button: widget.button,
      child: Row(
        children: [
          _ButtonTitle(title: widget.button.title),
          OneAxisJoystick(
            axis: axis,
            controller: controller,
            notifier: notifier,
          ),
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

class PackageSenderOneAxisJoystickController
    implements OneAxisJoystickController {
  PackageSenderOneAxisJoystickController({
    required this.sendCallback,
    required this.sendPeriod,
    this.onTapSend = const [],
  }) : packages = [];

  @protected
  final void Function(List<DataSourceOutgoingPackage> packages) sendCallback;

  @visibleForTesting
  final List<DataSourceOutgoingPackage> packages;

  @protected
  final Duration sendPeriod;

  @protected
  final List<DataSourceOutgoingPackage> onTapSend;

  @visibleForTesting
  Timer? timer;

  void setPackages(List<DataSourceOutgoingPackage> packages) {
    this.packages
      ..clear()
      ..addAll(packages);
  }

  void _cancel() {
    timer?.cancel();
    timer = null;
  }

  @override
  void onDragStart() {
    _cancel();
    Future<void>.delayed(const Duration(milliseconds: 40)).then((value) {
      sendCallback(packages);
      timer = Timer.periodic(
        sendPeriod,
        (timer) => sendCallback(packages),
      );
    });
  }

  @override
  void onDragUpdate(double delta) {}

  @override
  void onTap() {
    if (onTapSend.isEmpty) return;
    sendCallback(onTapSend);
  }

  @override
  void onDragEnd() {
    sendCallback(packages);
    _cancel();
  }

  void dispose() {
    _cancel();
  }
}
