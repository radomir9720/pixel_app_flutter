part of '../main_router.dart';

const _settingsRoute = AutoRoute<void>(
  page: EmptyRouterScreen,
  path: 'settings',
  name: RouteNames.settingsFlow,
  children: [
    AutoRoute<void>(
      initial: true,
      page: SettingsScreen,
    ),
    AutoRoute<void>(
      path: 'led-panel',
      page: LEDPanelScope,
      name: RouteNames.ledPanelFlow,
      children: [
        AutoRoute<void>(
          initial: true,
          page: LEDPanelScreen,
        ),
        CustomRoute(
          page: AddLEDConfigurationDialog,
          path: 'add-configuration',
          name: RouteNames.addConfigurationDialogRoute,
          customRouteBuilder: dialogRouteBuilder,
        ),
        CustomRoute(
          page: RemoveLEDConfigurationDialog,
          path: 'remove-configuration',
          name: RouteNames.removeConfigurationDialogRoute,
          customRouteBuilder: dialogRouteBuilder,
        ),
      ],
    ),
  ],
);
