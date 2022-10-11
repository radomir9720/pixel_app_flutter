import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/app/scopes/selected_data_source_scope.dart';
import 'package:pixel_app_flutter/presentation/screens/apps/apps_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/car_info/car_info_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/charging/charging_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/common/loading_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/data_source/data_source_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/general/general_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/home/home_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/navigator/navigator_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/settings/settings_screen.dart';

part 'main_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen|Scope,Route',
  routes: <AutoRoute>[
    CustomRoute<void>(
      path: '',
      initial: true,
      page: SelectedDataSourceScope,
      name: 'HomeFlow',
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
          path: 'data-source',
          page: DataSourceScreen,
        ),
      ],
    ),
    AutoRoute<void>(
      path: 'select-data-source',
      page: EmptyRouterPage,
      name: 'SelectDataSourceFlow',
      children: [
        AutoRoute<void>(
          initial: true,
          name: 'SelectDataSourceRoute',
          page: DataSourceScreen,
        ),
      ],
    ),
    CustomRoute<void>(
      path: 'loading',
      page: LoadingScreen,
      transitionsBuilder: TransitionsBuilders.noTransition,
    ),
  ],
)
class MainRouter extends _$MainRouter {}
