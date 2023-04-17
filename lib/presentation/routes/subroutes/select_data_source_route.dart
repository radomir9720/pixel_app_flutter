part of '../main_router.dart';

const _selectDataSourceRoute = AutoRoute<void>(
  page: SelectDataSourceScope,
  path: 'select-data-source',
  name: RouteNames.selectDataSourceFlow,
  children: [
    AutoRoute<void>(
      initial: true,
      page: DataSourceScreen,
    ),
    CustomRoute(
      page: SelectDeviceDialog,
      path: 'select-device',
      name: RouteNames.selectDeviceDialogRoute,
      customRouteBuilder: dialogRouteBuilder,
    ),
    CustomRoute(
      page: ConnectToDataSourceLoadingDialog,
      path: 'loading',
      name: RouteNames.connectToDataSourceLoadingDialogRoute,
      customRouteBuilder: dialogRouteBuilder,
    ),
    //
    _developerToolsRoute,
  ],
);
