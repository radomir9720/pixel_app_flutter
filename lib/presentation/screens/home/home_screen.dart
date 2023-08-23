import 'package:auto_route/auto_route.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/icons.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/molecules/side_nav_bar.dart';
import 'package:pixel_app_flutter/presentation/widgets/common/organisms/bottom_interfaces_menu.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/molecules/bottom_navigation_bar.dart';
import 'package:pixel_app_flutter/presentation/widgets/phone/organisms/bottom_sheet_interfaces_builder.dart';
import 'package:re_widgets/re_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        GeneralFlow(),
        CarInfoRoute(),
        NavigatorFlow(),
        AppsFlow(),
        ChargingRoute(),
        MotorRoute(),
      ],
      builder: (context, child, animation) {
        final tabsRouter = AutoTabsRouter.of(context);
        final screenData = Screen.of(context);
        final screenType = screenData.type;
        final landscape = !screenType.isHandset || screenData.isLandscape;
        final showSideNavBarTitle =
            !screenType.isHandset && screenData.size.width > 700;

        return BottomSheetInterfacesBuilder(
          enable: screenType.isHandset,
          builder: (sheetController) {
            if (landscape) sheetController.changeBottomPadding(0);

            return GradientScaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Stack(
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
                        isHandset: screenType.isHandset,
                        showTitle: showSideNavBarTitle,
                      )
                  ],
                ),
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
      orElse: () {
        return IntrinsicHeight(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 36).copyWith(bottom: 33),
            child: const BottomInterfacesMenu(),
          ),
        );
      },
      handset: () {
        if (!landscape) {
          return MeasureSize(
            onChange: onBottomNavBarSizeChange,
            child: BottomNavBar(
              onTap: context.onTabTap,
              onLongTap: context.onTabLongTap,
              activeIndex: tabsRouter.activeIndex,
              tabIcons: const [
                PixelIcons.car,
                PixelIcons.info,
                PixelIcons.navigator,
                PixelIcons.apps,
                PixelIcons.charging,
                PixelIcons.engine,
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
    required this.isHandset,
    this.showTitle = true,
  });

  @protected
  final TabsRouter tabsRouter;

  @protected
  final bool isHandset;

  @protected
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: isHandset ? 16 : 40,
      child: Center(
        child: SideNavBar(
          showTitle: showTitle,
          items: [
            SideNavBarItem(
              pageIndex: 0,
              icon: PixelIcons.car,
              title: context.l10n.generalTabTitle,
            ),
            if (isHandset)
              SideNavBarItem(
                pageIndex: 1,
                icon: PixelIcons.info,
                title: context.l10n.carInfoTabTitle,
              ),
            SideNavBarItem(
              pageIndex: 2,
              icon: PixelIcons.navigator,
              title: context.l10n.navigatorTabTitle,
            ),
            SideNavBarItem(
              pageIndex: 3,
              icon: PixelIcons.apps,
              title: context.l10n.appsTabTitle,
            ),
            SideNavBarItem(
              pageIndex: 4,
              icon: PixelIcons.charging,
              title: context.l10n.batteryTabTitle,
            ),
            SideNavBarItem(
              pageIndex: 5,
              icon: PixelIcons.engine,
              title: context.l10n.motorTabTitle,
            ),
          ],
          onTap: context.onTabTap,
          onLongTap: context.onTabLongTap,
          activeIndex: tabsRouter.activeIndex,
        ),
      ),
    );
  }
}

extension on BuildContext {
  Future<void> onTabTap(int index) async {
    if (index == 2) {
      if (mounted) {
        final fastAccess = read<NavigatorFastAccessBloc>().state.payload;

        if (fastAccess) {
          final selectedApp = read<NavigatorAppBloc>().state.payload;

          if (selectedApp != null) {
            final isInstalled = await LaunchApp.isAppInstalled(
              androidPackageName: selectedApp,
              iosUrlScheme: selectedApp,
            );

            if (isInstalled == true) {
              await LaunchApp.openApp(
                androidPackageName: selectedApp,
                iosUrlScheme: selectedApp,
                openStore: false,
              );
              return;
            }
          }
        }
      }
    }
    tabsRouter.setActiveIndex(index);
  }

  Future<void> onTabLongTap(int index) async {
    if (index == 2) tabsRouter.setActiveIndex(index);
  }
}
