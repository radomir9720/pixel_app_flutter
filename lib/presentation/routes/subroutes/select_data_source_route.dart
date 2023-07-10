part of '../main_router.dart';

const _selectDataSourceRoute = AutoRoute<void>(
  page: SelectDataSourceScope,
  path: 'select-data-source',
  name: RouteNames.selectDataSourceFlow,
  children: [
    AutoRoute<void>(
      path: '',
      page: EmptyRouterScreen,
      name: RouteNames.selectDataSourceGeneralFlow,
      children: [
        AutoRoute<void>(
          initial: true,
          page: DataSourceScreen,
        ),
        //
        _settingsRoute,
        //
        CustomRoute(
          page: SelectDeviceDialog,
          path: 'select-device',
          name: RouteNames.selectDeviceDialogRoute,
          customRouteBuilder: dialogRouteBuilder,
        ),
      ],
    ),
    CustomRoute<void>(
      path: 'loading',
      page: NonPopableLoadingScreen,
      fullscreenDialog: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
    AutoRoute(
      path: 'enter-serial-number',
      page: EnterSerialNumberScreen,
    ),
    //
    _developerToolsRoute,
  ],
);
