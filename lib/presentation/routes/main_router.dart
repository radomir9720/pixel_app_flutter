import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/app/scopes/developer_tools_scope.dart';
import 'package:pixel_app_flutter/app/scopes/selected_data_source_scope.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/presentation/screens/apps/apps_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/car_info/car_info_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/charging_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/common/loading_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/data_source/data_source_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/data_source/select_device_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/developer_tools_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/processed_exhange_logs_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/raw_exchange_logs_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/requests_exchange_logs_filter_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/requests_exchange_logs_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/widgets/integer_list_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/widgets/slider_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/general/general_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/home/home_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/navigator/navigator_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/settings/settings_screen.dart';

part 'main_router.gr.dart';

mixin RouteNames {
  static const homeFlow = 'HomeFlow';
  static const selectDataSourceFlow = 'SelectDataSourceFlow';
  static const developerToolsFlow = 'DeveloperToolsFlow';
  static const requestsExchangeLogsFlow = 'RequestsExchangeLogsFlow';
  static const requestsExchangeLogsFilterFlow =
      'RequestsExchangeLogsFilterFlow';
  //
  static const requestsExchangeLogsRoute = 'RequestsExchangeLogsRoute';
  static const selectDeviceDialogRoute = 'SelectDeviceDialogRoute';
  static const connectToDataSourceLoadingDialogRoute =
      'ConnectToDataSourceLoadingDialogRoute';
  static const changeParametersSubscriptionDialogRoute =
      'ChangeParametersSubscriptionDialogRoute';
  static const changeRequestPeriodDialogRoute =
      'ChangeRequestPeriodDialogRoute';
  static const changeHandshakeResponseTimeoutDialogRoute =
      'ChangeHandshakeResponseTimeoutDialogRoute';

  static const filterParameterIdDialogRoute = 'FilterParameterIdDialogRoute';
  static const filterRequestTypeDialogRoute = 'FilterRequestTypeDialogRoute';
  static const filterDirectionDialogRoute = 'FilterDirectionDialogRoute';
}

const _selectDataSourceRouter = AutoRoute<void>(
  page: EmptyRouterPage,
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
  ],
);

@MaterialAutoRouter(
  replaceInRouteName: 'Screen|Scope,Route',
  routes: <AutoRoute>[
    CustomRoute<void>(
      path: '',
      initial: true,
      page: SelectedDataSourceScope,
      name: RouteNames.homeFlow,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      children: [
        AutoRoute<void>(
          initial: true,
          page: HomeScreen,
          children: [
            AutoRoute<void>(
              path: 'general',
              page: GeneralScreen,
            ),
            AutoRoute<void>(
              path: 'car-info',
              page: CarInfoScreen,
            ),
            AutoRoute<void>(
              path: 'navigator',
              page: NavigatorScreen,
            ),
            AutoRoute<void>(
              path: 'apps',
              page: AppsScreen,
            ),
            AutoRoute<void>(
              path: 'charging',
              page: ChargingScreen,
            ),
          ],
        ),
        AutoRoute<void>(
          path: 'settings',
          page: SettingsScreen,
        ),
        AutoRoute<void>(
          path: 'developer-tools',
          name: RouteNames.developerToolsFlow,
          page: DeveloperToolsScope,
          children: [
            AutoRoute<void>(
              path: '',
              page: DeveloperToolsScreen,
            ),
            AutoRoute<void>(
              path: 'exchange-logs',
              page: EmptyRouterScreen,
              name: RouteNames.requestsExchangeLogsFlow,
              children: [
                AutoRoute(
                  page: RequestsExchangeLogsScreen,
                  initial: true,
                  name: RouteNames.requestsExchangeLogsRoute,
                  children: [
                    AutoRoute<void>(
                      path: 'processed',
                      page: ProcessedExchangeLogsScreen,
                    ),
                    AutoRoute<void>(
                      path: 'raw',
                      page: RawExchangeLogsScreen,
                    ),
                  ],
                ),
                AutoRoute<void>(
                  path: 'filter',
                  page: EmptyRouterScreen,
                  name: RouteNames.requestsExchangeLogsFilterFlow,
                  children: [
                    AutoRoute(
                      initial: true,
                      page: RequestsExchangeLogsFilterScreen,
                    ),
                    CustomRoute<List<int>>(
                      page: IntegerListDialog,
                      path: 'parameter-id',
                      name: RouteNames.filterParameterIdDialogRoute,
                      customRouteBuilder: dialogRouteBuilder,
                    ),
                    CustomRoute<List<int>>(
                      page: IntegerListDialog,
                      path: 'request-type',
                      name: RouteNames.filterRequestTypeDialogRoute,
                      customRouteBuilder: dialogRouteBuilder,
                    ),
                    CustomRoute<List<int>>(
                      page: IntegerListDialog,
                      path: 'direction',
                      name: RouteNames.filterDirectionDialogRoute,
                      customRouteBuilder: dialogRouteBuilder,
                    ),
                  ],
                ),
              ],
            ),
            CustomRoute<List<int>>(
              page: IntegerListDialog,
              path: 'change-parameters-subscription',
              name: RouteNames.changeParametersSubscriptionDialogRoute,
              customRouteBuilder: dialogRouteBuilder,
            ),
            CustomRoute<int>(
              page: SliderDialog,
              path: 'change-request-period',
              name: RouteNames.changeRequestPeriodDialogRoute,
              customRouteBuilder: dialogRouteBuilder,
            ),
            CustomRoute<int>(
              page: SliderDialog,
              path: 'change-handshake-response-timeout',
              name: RouteNames.changeHandshakeResponseTimeoutDialogRoute,
              customRouteBuilder: dialogRouteBuilder,
            ),
          ],
        ),
        _selectDataSourceRouter,
      ],
    ),
    _selectDataSourceRouter,
    CustomRoute<void>(
      path: 'loading',
      page: LoadingScreen,
      fullscreenDialog: true,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
  ],
)
class MainRouter extends _$MainRouter {}

Route<T> dialogRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return DialogRoute(
    settings: page,
    builder: (context) => child,
    context: context,
    // expanded: true,
  );
}
