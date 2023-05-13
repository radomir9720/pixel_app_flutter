import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/blocs/lights_cubit.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/atoms/car_interface_list_tile.dart';
import 'package:re_seedwork/re_seedwork.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tabsRouter = AutoTabsRouter.of(context);
    final isHandset = Screen.of(context).type.isHandset;

    // If screenType changed from handset to other type, then changing tab to
    // general, as CarInfoScreen should be available only on handset screen type
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (tabsRouter.activeIndex == 1 && !isHandset) {
        tabsRouter.setActiveIndex(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.carInfoTabTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        const Divider(),
        Expanded(
          child: ListView(
            primary: false,
            children: [
              // CarInterfaceListTile(
              //   title: context.l10n.lightsInterfaceTitle,
              //   status: context.l10n.autoModeLightsStatus,
              //   icon: PixelIcons.light,
              //   state: CarInterfaceState.primary,
              //   onPressed: () {},
              // ),
              _CarInfoTileBlocWrapper<TwoBoolsState>(
                selector: (state) => state.sideBeam,
                title: context.l10n.parkingLightsButtonCaption,
                icon: PixelIcons.light,
                onPressed: context.read<LightsCubit>().toggleSideBeam,
              ),
              _CarInfoTileBlocWrapper(
                selector: (state) => state.lowBeam,
                title: context.l10n.lowBeamButtonCaption,
                icon: PixelIcons.light,
                onPressed: context.read<LightsCubit>().toggleLowBeam,
              ),
              _CarInfoTileBlocWrapper(
                selector: (state) => state.highBeam,
                title: context.l10n.highBeamButtonCaption,
                icon: PixelIcons.light,
                onPressed: context.read<LightsCubit>().toggleHighBeam,
              ),
              _CarInfoTileBlocWrapper<TwoBoolsState>(
                selector: (state) => state.leftTurnSignal,
                title: context.l10n.leftBlinkerButtonCaption,
                icon: Icons.arrow_circle_left,
                onPressed: context.read<LightsCubit>().toggleLeftTurnSignal,
              ),
              _CarInfoTileBlocWrapper<TwoBoolsState>(
                selector: (state) => state.rightTurnSignal,
                title: context.l10n.rightBlinkerButtonCaption,
                icon: Icons.arrow_circle_right,
                onPressed: context.read<LightsCubit>().toggleRightTurnSignal,
              ),
              _CarInfoTileBlocWrapper<TwoBoolsState>(
                selector: (state) => state.hazardBeam,
                title: context.l10n.hazardBeamButtonCaption,
                icon: Icons.warning_amber,
                onPressed: context.read<LightsCubit>().toggleHazardBeam,
              ),

              // CarInterfaceListTile(
              //   title: context.l10n.frontTrunkInterfaceTitle,
              //   status: context.l10n.unlockedInterfaceStatus,
              //   icon: PixelIcons.unlocked,
              //   state: CarInterfaceState.success,
              //   onPressed: () {},
              // ),
              // CarInterfaceListTile(
              //   title: context.l10n.leftDoorInterfaceTitle,
              //   status: context.l10n.lockedInterfaceStatus,
              //   icon: PixelIcons.locked,
              //   state: CarInterfaceState.error,
              //   onPressed: () {},
              // ),
              // CarInterfaceListTile(
              //   title: context.l10n.rightDoorInterfaceTitle,
              //   status: context.l10n.unlockedInterfaceStatus,
              //   icon: PixelIcons.unlocked,
              //   state: CarInterfaceState.success,
              //   onPressed: () {},
              // ),
              // CarInterfaceListTile(
              //   title: context.l10n.rearTrunkInterfaceTitle,
              //   status: context.l10n.lockedInterfaceStatus,
              //   icon: PixelIcons.locked,
              //   state: CarInterfaceState.error,
              //   onPressed: () {},
              // ),
            ],
          ),
        )
      ],
    );
  }
}

class _CarInfoTileBlocWrapper<T> extends StatelessWidget {
  const _CarInfoTileBlocWrapper({
    super.key,
    required this.selector,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @protected
  final AsyncData<T, LightsStateError> Function(LightsState) selector;

  @protected
  final String title;

  @protected
  final IconData icon;

  @protected
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<LightsCubit, LightsState, LightState<T>>(
      selector: selector,
      builder: (context, state) {
        final payload = state.payload;
        final _isOn = (payload is bool
                ? payload
                : payload is TwoBoolsState
                    ? payload.isOn
                    : null)
            .checkNotNull('Payload should be either bool or TwoBoolsState');

        return CarInterfaceListTile(
          title: title,
          status: !state.isExecuted
              ? context.l10n.loadingStatusMessage
              : _isOn
                  ? context.l10n.onShortStatusMessage
                  : context.l10n.offShortStatusMessage,
          icon: icon,
          state: !state.isExecuted
              ? CarInterfaceState.primary
              : _isOn
                  ? CarInterfaceState.success
                  : CarInterfaceState.error,
          onPressed: onPressed,
        );
      },
    );
  }
}
