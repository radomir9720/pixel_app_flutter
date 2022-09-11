import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/measure_size.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/side_nav_bar.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/organisms/bottom_interfaces_menu.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/molecules/bottom_navigation_bar.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/organisms/bottom_sheet_interfaces_builder.dart';

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
        final screenData = Screen.of(context);
        final screenType = screenData.type;
        final landscape = !screenType.isHandset ||
            screenData.size.width > screenData.size.height;

        return BottomSheetInterfacesBuilder(
          enable: screenType.isHandset,
          builder: (sheetController) {
            if (landscape) sheetController.changeBottomPadding(0);

            return GradientScaffold(
              body: Stack(
                children: [
                  Positioned.fill(
                    child: FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                  ),
                  if (landscape)
                    _SideNavBar(
                      tabsRouter: tabsRouter,
                      showTitle: !screenType.isHandset,
                    )
                ],
              ),
              bottomNavigationBar: _BottomNavBar(
                tabsRouter: tabsRouter,
                screenData: screenData,
                onBottomNavBarSizeChange: (size) {
                  sheetController.changeBottomPadding(size.height);
                },
              ),
              extendBody: true,
              backgroundColor: Colors.transparent,
            );
          },
        );
      },
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.tabsRouter,
    required this.screenData,
    required this.onBottomNavBarSizeChange,
  });

  @protected
  final TabsRouter tabsRouter;

  @protected
  final ScreenData screenData;

  @protected
  final ValueSetter<Size> onBottomNavBarSizeChange;

  @override
  Widget build(BuildContext context) {
    final landscape = !screenData.type.isHandset || !screenData.isPortrait;

    return screenData.whenType(
      orElse: (_, __) {
        return IntrinsicHeight(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 36).copyWith(bottom: 33),
            child: const BottomInterfacesMenu(),
          ),
        );
      },
      handset: (_, __) {
        if (!landscape) {
          return MeasureSize(
            onChange: onBottomNavBarSizeChange,
            child: BottomNavBar(
              onTap: tabsRouter.setActiveIndex,
              activeIndex: tabsRouter.activeIndex,
              tabIcons: const [
                PixelIcons.car,
                PixelIcons.info,
                PixelIcons.navigator,
                PixelIcons.apps,
                PixelIcons.charging,
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _SideNavBar extends StatelessWidget {
  const _SideNavBar({
    required this.tabsRouter,
    required this.showTitle,
  });

  @protected
  final TabsRouter tabsRouter;

  @protected
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      bottom: 0,
      left: 32,
      child: Center(
        child: SideNavBar(
          showTitle: showTitle,
          items: [
            SideNavBarItem(
              icon: PixelIcons.car,
              title: context.l10n.generalTabTitle,
            ),
            SideNavBarItem(
              icon: PixelIcons.info,
              title: context.l10n.carInfoTabTitle,
            ),
            SideNavBarItem(
              icon: PixelIcons.navigator,
              title: context.l10n.navigatorTabTitle,
            ),
            SideNavBarItem(
              icon: PixelIcons.apps,
              title: context.l10n.appsTabTitle,
            ),
            SideNavBarItem(
              icon: PixelIcons.charging,
              title: context.l10n.chargingTabTitle,
            ),
          ],
          onTap: tabsRouter.setActiveIndex,
          activeIndex: tabsRouter.activeIndex,
        ),
      ),
    );
  }
}
