part of '../main_router.dart';

final _homeRoute = AutoRoute(
  path: '',
  page: HomeRoute.page,
  children: [
    AutoRoute(
      path: 'general',
      page: GeneralFlow.page,
      children: [
        AutoRoute(
          path: '',
          page: GeneralRoute.page,
        ),
        CustomRoute(
          path: 'led-switcher-dialog',
          page: LEDSwitcherDialogRoute.page,
          customRouteBuilder: dialogRouteBuilder,
        ),
      ],
    ),
    AutoRoute(
      path: 'car-info',
      page: CarInfoRoute.page,
    ),
    AutoRoute(
      path: 'navigator',
      page: NavigatorFlow.page,
      children: [
        AutoRoute(
          path: '',
          page: NavigatorRoute.page,
        ),
        CustomRoute(
          path: 'enable-fast-access',
          page: EnableFastAccessDialogRoute.page,
          customRouteBuilder: enableFastAccessDialofRouteBuilder,
        ),
      ],
    ),
    AutoRoute(
      path: 'apps',
      page: AppsFlow.page,
      children: [
        AutoRoute(
          path: '',
          page: AppsRoute.page,
        ),
      ],
    ),
    AutoRoute(
      path: 'charging',
      page: ChargingRoute.page,
    ),
    AutoRoute(
      path: 'motor',
      page: MotorRoute.page,
    ),
  ],
);

Route<T> enableFastAccessDialofRouteBuilder<T>(
  BuildContext context,
  Widget child,
  AutoRoutePage<T> page,
) {
  return dialogRouteBuilder<T>(
    context,
    child,
    page,
    barrierColor: Colors.transparent,
  );
}

@RoutePage(name: 'NavigatorFlow')
class NavigatorScope extends AutoRouter {
  const NavigatorScope({super.key});
}
