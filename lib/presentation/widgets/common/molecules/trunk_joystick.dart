import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package/outgoing/outgoing_data_source_packages.dart';
import 'package:pixel_app_flutter/domain/data_source/models/package_data/package_data.dart';
import 'package:pixel_app_flutter/presentation/screens/user_defined_buttons/widgets/buttons/one_axis_joystick_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/one_axis_joystick.dart';

class TrunkJoystick extends StatefulWidget {
  const TrunkJoystick({
    super.key,
    required this.parameterId,
    this.mainAxisSize = 100,
    this.crossAxisSize = 30,
    this.arrowIconPadding = 10,
    this.thumbSize = 30,
    this.iconSize = 24,
  });

  const TrunkJoystick.big({
    super.key,
    required this.parameterId,
    this.mainAxisSize = 150,
    this.crossAxisSize = 45,
    this.thumbSize = 45,
    this.iconSize = 36,
    this.arrowIconPadding = 10,
  });

  @protected
  final DataSourceParameterId parameterId;

  @protected
  final double mainAxisSize;

  @protected
  final double crossAxisSize;

  @protected
  final double arrowIconPadding;

  @protected
  final double thumbSize;

  @protected
  final double iconSize;

  @override
  State<TrunkJoystick> createState() => _TrunkJoystickState();
}

class _TrunkJoystickState extends State<TrunkJoystick>
    with SingleTickerProviderStateMixin {
  late final PackageSenderOneAxisJoystickController controller;
  late final OneAxisJoystickNotifier notifier;

  @override
  void initState() {
    super.initState();
    controller = PackageSenderOneAxisJoystickController(
      onTapSend: [
        OutgoingToggleRequestPackage(
          bytesConvertible: const Int8ToggleBody(value: 0),
          parameterId: widget.parameterId,
        ),
      ],
      sendCallback: (packages) {
        for (final package in packages) {
          context.read<OutgoingPackagesCubit>().sendPackage(package);
        }
      },
      sendPeriod: const Duration(milliseconds: 333),
    );
    notifier = OneAxisJoystickNotifier(
      vsync: this,
      onPan: (value) {
        controller.setPackages(
          [
            OutgoingToggleRequestPackage(
              bytesConvertible: Int8ToggleBody(value: (value * 100).toInt()),
              parameterId: widget.parameterId,
            ),
          ],
        );
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
    return OneAxisJoystick(
      axis: Axis.vertical,
      controller: controller,
      notifier: notifier,
      mainAxisSize: widget.mainAxisSize,
      crossAxisSize: widget.crossAxisSize,
      thumbSize: widget.thumbSize,
      iconSize: widget.iconSize,
      arrowIconPadding: widget.arrowIconPadding,
    );
  }
}
