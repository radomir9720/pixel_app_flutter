part of '../main_router.dart';

const _homeRoute = AutoRoute<void>(
  initial: true,
  page: HomeScreen,
  children: [
    AutoRoute<void>(
      path: 'general',
      page: GeneralScreenWrapper,
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
  ],
);
