import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/measure_size.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/unbounded_hit_test_stack.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/icon_button.dart';
import 'package:pixel_app_flutter/presentation/widgets/tablet/atoms/car_interface_pointer.dart';
import 'package:pixel_app_flutter/presentation/widgets/tablet/molecules/car_interface_switcher.dart';

class CarWidget extends StatefulWidget {
  const CarWidget({super.key});

  @override
  State<CarWidget> createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> {
  Size carSize = Size.zero;

  bool leftDoorOpened = true;
  bool rightDoorOpened = false;
  bool trunkOpened = false;
  bool frontTrunkOpened = true;

  IconData _getIcon(bool opened) =>
      opened ? PixelIcons.unlocked : PixelIcons.locked;

  PIconButtonState _getState(bool opened) =>
      opened ? PIconButtonState.success : PIconButtonState.error;

  @protected
  static const carAssetPath = 'assets/svg/car.svg';

  @override
  Widget build(BuildContext context) {
    final buttonScaleCoef = carSize.width / 232;

    // ignore: avoid_positional_boolean_parameters
    String getStatus(bool opened) => opened
        ? context.l10n.unlockedInterfaceStatus
        : context.l10n.lockedInterfaceStatus;

    return UnboundedHitTestStack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: MeasureSize(
            onChange: (size) {
              if (size != carSize) {
                carSize = size;
                if (mounted) setState(() {});
              }
            },
            child: AspectRatio(
              aspectRatio: .3972,
              child: SvgPicture.asset(carAssetPath),
            ),
          ),
        ),
        if (carSize != Size.zero) ...[
          // Left door
          Positioned(
            top: 0,
            right: carSize.width * .88,
            bottom: 0,
            child: Transform.scale(
              scale: buttonScaleCoef,
              alignment: Alignment.centerRight,
              child: CarInterfaceSwitcher(
                icon: _getIcon(leftDoorOpened),
                state: _getState(leftDoorOpened),
                onPressed: () => setState(() {
                  leftDoorOpened = !leftDoorOpened;
                }),
                title: context.l10n.doorInterfaceTitle,
                status: getStatus(leftDoorOpened),
                pointerSide: CarInterfacePointerSide.right,
                titleSide: CarInterfaceSwitcherTitleSide.left,
              ),
            ),
          ),
          // Right door
          Positioned(
            top: 0,
            left: carSize.width * .88,
            bottom: 0,
            child: Transform.scale(
              scale: buttonScaleCoef,
              alignment: Alignment.centerLeft,
              child: CarInterfaceSwitcher(
                icon: _getIcon(rightDoorOpened),
                state: _getState(rightDoorOpened),
                onPressed: () => setState(() {
                  rightDoorOpened = !rightDoorOpened;
                }),
                title: context.l10n.doorInterfaceTitle,
                status: getStatus(rightDoorOpened),
                pointerSide: CarInterfacePointerSide.left,
                titleSide: CarInterfaceSwitcherTitleSide.right,
              ),
            ),
          ),
          // Lights
          Positioned(
            top: carSize.height * .02,
            right: carSize.width * .88,
            child: Transform.scale(
              scale: buttonScaleCoef,
              alignment: Alignment.centerRight,
              child: CarInterfaceSwitcher(
                pointerLength: 64,
                icon: PixelIcons.light,
                state: PIconButtonState.primary,
                title: context.l10n.lightsInterfaceTitle,
                status: context.l10n.autoModeLightsStatus,
                onPressed: () {},
                pointerSide: CarInterfacePointerSide.right,
                titleSide: CarInterfaceSwitcherTitleSide.left,
              ),
            ),
          ),
          // Front Trunk
          Positioned(
            top: carSize.height * .07,
            right: 0,
            left: 0,
            child: Transform.scale(
              scale: buttonScaleCoef,
              alignment: Alignment.topCenter,
              child: Center(
                child: CarInterfaceSwitcher(
                  icon: _getIcon(frontTrunkOpened),
                  state: _getState(frontTrunkOpened),
                  onPressed: () => setState(() {
                    frontTrunkOpened = !frontTrunkOpened;
                  }),
                  title: context.l10n.trunkInterfaceTitle,
                  status: getStatus(frontTrunkOpened),
                ),
              ),
            ),
          ),
          // Trunk
          Positioned(
            bottom: carSize.height * .07,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: buttonScaleCoef,
              alignment: Alignment.bottomCenter,
              child: Center(
                child: CarInterfaceSwitcher(
                  icon: _getIcon(trunkOpened),
                  state: _getState(trunkOpened),
                  onPressed: () => setState(() {
                    trunkOpened = !trunkOpened;
                  }),
                  title: context.l10n.trunkInterfaceTitle,
                  status: getStatus(trunkOpened),
                  titleSide: CarInterfaceSwitcherTitleSide.bottom,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
