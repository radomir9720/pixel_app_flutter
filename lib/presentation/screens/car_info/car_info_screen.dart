import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/atoms/car_interface_list_tile.dart';

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
    final isHandset = Screen.of(context, watch: false).type.isHandset;

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
    final isLandscape = Screen.of(context).isLandscape;

    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 32).copyWith(
        left: isLandscape ? 87 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.carInfoTabTitle,
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 20),
          const Divider(),
          Expanded(
            child: ListView(
              primary: false,
              children: [
                CarInterfaceListTile(
                  title: context.l10n.lightsInterfaceTitle,
                  status: context.l10n.autoModeLightsStatus,
                  icon: PixelIcons.light,
                  state: CarInterfaceState.primary,
                  onPressed: () {},
                ),
                CarInterfaceListTile(
                  title: context.l10n.frontTrunkInterfaceTitle,
                  status: context.l10n.unlockedInterfaceStatus,
                  icon: PixelIcons.unlocked,
                  state: CarInterfaceState.success,
                  onPressed: () {},
                ),
                CarInterfaceListTile(
                  title: context.l10n.leftDoorInterfaceTitle,
                  status: context.l10n.lockedInterfaceStatus,
                  icon: PixelIcons.locked,
                  state: CarInterfaceState.error,
                  onPressed: () {},
                ),
                CarInterfaceListTile(
                  title: context.l10n.rightDoorInterfaceTitle,
                  status: context.l10n.unlockedInterfaceStatus,
                  icon: PixelIcons.unlocked,
                  state: CarInterfaceState.success,
                  onPressed: () {},
                ),
                CarInterfaceListTile(
                  title: context.l10n.rearTrunkInterfaceTitle,
                  status: context.l10n.lockedInterfaceStatus,
                  icon: PixelIcons.locked,
                  state: CarInterfaceState.error,
                  onPressed: () {},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
