import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/atoms/responsive_padding.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/trunk_joystick.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/atoms/car_interface_list_tile.dart';
import 'package:re_seedwork/re_seedwork.dart';

@RoutePage()
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
    return ResponsivePadding(
      child: Column(
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
                BlocSelector<GeneralInterfacesCubit, GeneralInterfacesState,
                    AsyncData<bool, ToggleStateError>>(
                  selector: (state) => state.leftDoor,
                  builder: (context, state) {
                    return CarInterfaceListTile(
                      title: context.l10n.leftDoorInterfaceTitle,
                      status: context.doorStatus(state),
                      icon: state.payload
                          ? PixelIcons.unlocked
                          : PixelIcons.locked,
                      state: state.tileState,
                      onPressed:
                          context.read<GeneralInterfacesCubit>().toggleLeftDoor,
                    );
                  },
                ),
                BlocSelector<GeneralInterfacesCubit, GeneralInterfacesState,
                    AsyncData<bool, ToggleStateError>>(
                  selector: (state) => state.rightDoor,
                  builder: (context, state) {
                    return CarInterfaceListTile(
                      title: context.l10n.rightDoorInterfaceTitle,
                      status: context.doorStatus(state),
                      icon: state.payload
                          ? PixelIcons.unlocked
                          : PixelIcons.locked,
                      state: state.tileState,
                      onPressed: context
                          .read<GeneralInterfacesCubit>()
                          .toggleRightDoor,
                    );
                  },
                ),
                _CarInfoLightTileBlocWrapper<TwoBoolsState>(
                  selector: (state) => state.hazardBeam,
                  title: context.l10n.hazardBeamButtonCaption,
                  icon: Icons.warning_amber,
                  onPressed: context.read<LightsCubit>().toggleHazardBeam,
                ),
                _CarInfoLightTileBlocWrapper<bool>(
                  selector: (state) => state.reverse,
                  title: context.l10n.reverseLightButtonCaption,
                  icon: Icons.keyboard_double_arrow_down_sharp,
                  onPressed: context.read<LightsCubit>().toggleReverseLight,
                ),
                _CarInfoLightTileBlocWrapper<bool>(
                  selector: (state) => state.brake,
                  title: context.l10n.brakeLightButtonCaption,
                  icon: Icons.stop_circle_outlined,
                  onPressed: context.read<LightsCubit>().toggleBrakeLight,
                ),
                _CarInfoLightTileBlocWrapper<bool>(
                  selector: (state) => state.cabin,
                  title: context.l10n.cabinLightButtonCaption,
                  icon: PixelIcons.light,
                  onPressed: context.read<LightsCubit>().toggleCabinLight,
                ),
                _CarInfoScreenListTile(
                  title: context.l10n.frontTrunkInterfaceTitle,
                  trailing: const TrunkJoystick(
                    parameterId: DataSourceParameterId.hood(),
                  ),
                ),
                _CarInfoScreenListTile(
                  title: context.l10n.rearTrunkInterfaceTitle,
                  trailing: const TrunkJoystick(
                    parameterId: DataSourceParameterId.trunk(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CarInfoScreenListTile extends StatelessWidget {
  const _CarInfoScreenListTile({
    required this.title,
    this.trailing,
  });

  @protected
  final String title;

  @protected
  final Widget? trailing;

  @protected
  static const kTitleTextStyle = TextStyle(
    fontSize: 15,
    height: 1.21,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 4,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: kTitleTextStyle.copyWith(color: context.colors.text),
                ),
              ),
              const SizedBox(width: 16),
              trailing ?? const SizedBox.shrink(),
            ],
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}

class _CarInfoLightTileBlocWrapper<T> extends StatelessWidget {
  const _CarInfoLightTileBlocWrapper({
    super.key,
    required this.selector,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @protected
  final AsyncData<T, ToggleStateError> Function(LightsState) selector;

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

extension on BuildContext {
  String doorStatus(AsyncData<bool, ToggleStateError> state) {
    return state.maybeWhen(
      loading: (payload) => l10n.waitingInterfaceStatus,
      orElse: (payload) => payload
          ? l10n.openedShortStatusMessage
          : l10n.closedShortStatusMessage,
    );
  }
}

extension on AsyncData<bool, ToggleStateError> {
  CarInterfaceState get tileState {
    return maybeWhen(
      orElse: (payload) {
        return payload ? CarInterfaceState.success : CarInterfaceState.error;
      },
      loading: (_) => CarInterfaceState.primary,
    );
  }
}
