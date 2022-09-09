import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/molecules/bottom_navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        GeneralRoute(),
        CarInfoRoute(),
        NavigatorRoute(),
        AppsRoute(),
        ChargingRoute(),
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);

        return GradientScaffold(
          body: FadeTransition(
            opacity: animation,
            child: child,
          ),
          bottomNavigationBar: BottomNavBar(
            activeIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            tabIcons: const [
              PixelIcons.car,
              PixelIcons.info,
              PixelIcons.navigator,
              PixelIcons.apps,
              PixelIcons.charging,
            ],
          ),
        );
      },
    );
  }
}
