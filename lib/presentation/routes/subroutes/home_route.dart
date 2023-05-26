part of '../main_router.dart';

const _homeRoute = AutoRoute<void>(
  initial: true,
  page: HomeScreen,
  children: [
    AutoRoute<void>(
      path: 'general',
      page: GeneralScope,
      name: RouteNames.generalFlow,
      children: [
        AutoRoute<void>(
          initial: true,
          page: GeneralScreen,
        ),
        CustomRoute<bool>(
          path: 'led-switcher-dialog',
          name: RouteNames.ledSwitcherDialogRoute,
          page: LEDPanelSwitcherDialog,
          customRouteBuilder: dialogRouteBuilder,
        ),
      ],
    ),
    AutoRoute<void>(
      path: 'car-info',
      page: CarInfoScreen,
    ),
    AutoRoute<void>(
      path: 'navigator',
      page: EmptyRouterScreen,
      name: RouteNames.navigatorFlow,
      children: [
        AutoRoute<void>(
          initial: true,
          page: NavigatorScreen,
        ),
        CustomRoute<bool>(
          path: 'enable-fast-access',
          name: RouteNames.enableFastAccessDialogRoute,
          page: EnableFastAccessDialog,
          customRouteBuilder: enableFastAccessDialofRouteBuilder,
        ),
      ],
    ),
    AutoRoute<void>(
      path: 'apps',
      page: AppsScope,
      name: RouteNames.appsFlow,
      children: [
        AutoRoute<void>(
          path: '',
          page: AppsScreen,
        ),
      ],
    ),
    AutoRoute<void>(
      path: 'charging',
      page: ChargingScreenWrapper,
    ),
    AutoRoute<void>(
      path: 'motor',
      page: MotorScreenWrapper,
    ),
  ],
);

Route<T> enableFastAccessDialofRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return dialogRouteBuilder<T>(
    context,
    child,
    page,
    barrierColor: Colors.transparent,
  );
}
