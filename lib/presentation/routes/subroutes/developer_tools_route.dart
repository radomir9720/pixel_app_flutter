part of '../main_router.dart';

const _developerToolsRoute = AutoRoute<void>(
  path: 'developer-tools',
  name: RouteNames.developerToolsFlow,
  page: DeveloperToolsScope,
  children: [
    AutoRoute<void>(
      path: '',
      page: DeveloperToolsScreen,
    ),
    AutoRoute<void>(
      path: 'packages-exchange-console',
      page: PackagesExchangeConsoleScreen,
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
);
