part of '../main_router.dart';

AutoRoute _selectDataSourceRoute({bool root = true}) => AutoRoute(
      page: SelectDataSourceFlow.page,
      path: '${root ? '/' : ''}select-data-source',
      children: [
        AutoRoute(
          path: '',
          page: SelectDataSourceGeneralFlow.page,
          children: [
            AutoRoute(
              path: '',
              page: DataSourceRoute.page,
            ),
            //
            _settingsRoute,
            //
            CustomRoute(
              page: SelectDeviceDialogRoute.page,
              path: 'select-device',
              customRouteBuilder: dialogRouteBuilder,
            ),
          ],
        ),
        CustomRoute(
          path: 'loading',
          page: NonPopableLoadingRoute.page,
          fullscreenDialog: true,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        AutoRoute(
          path: 'enter-serial-number',
          page: EnterSerialNumberRoute.page,
        ),
        //
      ],
    );

@RoutePage(name: 'SelectDataSourceGeneralFlow')
class SelectDataSourceGeneralScope extends AutoRouter {
  const SelectDataSourceGeneralScope({super.key});
}
