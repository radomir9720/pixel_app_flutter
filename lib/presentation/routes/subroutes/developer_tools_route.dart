part of '../main_router.dart';

AutoRoute _developerToolsRoute({bool selectedDS = true}) => AutoRoute(
      path: '${selectedDS ? '' : '/'}developer-tools',
      page: DeveloperToolsFlow.page,
      children: [
        AutoRoute(
          path: '',
          page: DeveloperToolsRoute.page,
        ),
        if (selectedDS)
          AutoRoute(
            path: 'packages-exchange-console',
            page: PackagesExchangeConsoleRoute.page,
          ),
        AutoRoute(
          path: 'exchange-logs',
          page: RequestsExchangeLogsFlow.page,
          children: [
            AutoRoute(
              page: RequestsExchangeLogsRoute.page,
              initial: true,
              children: [
                AutoRoute(
                  path: 'processed',
                  page: ProcessedExchangeLogsRoute.page,
                ),
                AutoRoute(
                  path: 'raw',
                  page: RawExchangeLogsRoute.page,
                ),
              ],
            ),
          ],
        ),
        AutoRoute(
          path: 'filter',
          page: RequestsExchangeLogsFilterFlow.page,
          children: [
            AutoRoute(
              initial: true,
              page: RequestsExchangeLogsFilterRoute.page,
            ),
            CustomRoute(
              page: FilterParameterIdDialogRoute.page,
              path: 'parameter-id',
              customRouteBuilder: dialogRouteBuilder,
            ),
            CustomRoute(
              page: FilterRequestTypeDialogRoute.page,
              path: 'request-type',
              customRouteBuilder: dialogRouteBuilder,
            ),
            CustomRoute(
              page: FilterDirectionDialogRoute.page,
              path: 'direction',
              customRouteBuilder: dialogRouteBuilder,
            ),
          ],
        ),
        CustomRoute(
          page: ChangeParametersSubscriptionDialogRoute.page,
          path: 'change-parameters-subscription',
          customRouteBuilder: dialogRouteBuilder,
        ),
        CustomRoute(
          page: ChangeRequestPeriodDialogRoute.page,
          path: 'change-request-period',
          customRouteBuilder: dialogRouteBuilder,
        ),
        CustomRoute(
          page: ChangeHandshakeResponseTimeoutDialogRoute.page,
          path: 'change-handshake-response-timeout',
          customRouteBuilder: dialogRouteBuilder,
        ),
      ],
    );

@RoutePage(name: 'RequestsExchangeLogsFlow')
class RequestsExchangeLogsScope extends AutoRouter {
  const RequestsExchangeLogsScope({super.key});
}

@RoutePage(name: 'RequestsExchangeLogsFilterFlow')
class RequestsExchangeLogsFilterScope extends AutoRouter {
  const RequestsExchangeLogsFilterScope({super.key});
}

@RoutePage<List<int>>(name: 'FilterParameterIdDialogRoute')
class FilterParameterIdDialog extends IntegerListDialog {
  const FilterParameterIdDialog({
    super.key,
    required super.title,
    required super.alwasysVisibleOptions,
    required super.initialChoosedOptions,
    super.validator,
  });
}

@RoutePage<List<int>>(name: 'FilterRequestTypeDialogRoute')
class FilterRequestTypeDialog extends IntegerListDialog {
  const FilterRequestTypeDialog({
    super.key,
    required super.title,
    required super.alwasysVisibleOptions,
    required super.initialChoosedOptions,
    super.validator,
  });
}

@RoutePage<List<int>>(name: 'FilterDirectionDialogRoute')
class FilterDirectionDialog extends IntegerListDialog {
  const FilterDirectionDialog({
    super.key,
    required super.title,
    required super.alwasysVisibleOptions,
    required super.initialChoosedOptions,
    super.validator,
  });
}

@RoutePage<List<int>>(name: 'ChangeParametersSubscriptionDialogRoute')
class ChangeParametersSubscriptionDialog extends IntegerListDialog {
  const ChangeParametersSubscriptionDialog({
    super.key,
    required super.title,
    required super.alwasysVisibleOptions,
    required super.initialChoosedOptions,
    super.validator,
  });
}

@RoutePage<int>(name: 'ChangeRequestPeriodDialogRoute')
class ChangeRequestPeriodDialog extends SliderDialog {
  const ChangeRequestPeriodDialog({
    super.key,
    required super.initialValue,
    required super.title,
    super.maxValueInMillis,
  });
}

@RoutePage<int>(name: 'ChangeHandshakeResponseTimeoutDialogRoute')
class ChangeHandshakeResponseTimeoutDialog extends SliderDialog {
  const ChangeHandshakeResponseTimeoutDialog({
    super.key,
    required super.initialValue,
    required super.title,
    super.maxValueInMillis,
  });
}
