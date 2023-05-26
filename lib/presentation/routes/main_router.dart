import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pixel_app_flutter/app/scopes/flows/apps_scope.dart';
import 'package:pixel_app_flutter/app/scopes/flows/developer_tools_scope.dart';
import 'package:pixel_app_flutter/app/scopes/flows/general_scope.dart';
import 'package:pixel_app_flutter/app/scopes/flows/led_panel_scope.dart';
import 'package:pixel_app_flutter/app/scopes/flows/select_data_source_scope.dart';
import 'package:pixel_app_flutter/app/scopes/flows/selected_data_source_scope.dart';
import 'package:pixel_app_flutter/app/scopes/screens/charging_screen_wrapper.dart';
import 'package:pixel_app_flutter/app/scopes/screens/motor_screen_wrapper.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:pixel_app_flutter/presentation/screens/apps/apps_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/car_info/car_info_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/common/loading_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/data_source/data_source_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/data_source/select_device_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/developer_tools_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/packages_exchange_console_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/processed_exhange_logs_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/raw_exchange_logs_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/requests_exchange_logs_filter_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/requests_exchange_logs_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/widgets/integer_list_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/developer_tools/widgets/slider_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/general/general_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/general/widgets/led_panel_switcher_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/home/home_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/navigator/navigator_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/navigator/widgets/enable_fast_access_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/settings/led_panel_screen/add_led_configuration_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/settings/led_panel_screen/led_panel_screen.dart';
import 'package:pixel_app_flutter/presentation/screens/settings/led_panel_screen/remove_led_configuration_dialog.dart';
import 'package:pixel_app_flutter/presentation/screens/settings/settings_screen.dart';

part 'main_router.gr.dart';
part 'route_names.dart';
part 'subroutes/developer_tools_route.dart';
part 'subroutes/settings_route.dart';
part 'subroutes/home_route.dart';
part 'subroutes/select_data_source_route.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'ScreenWrapper|Screen|PageWrapper|Page|Scope,Route',
  routes: <AutoRoute>[
    CustomRoute<void>(
      path: '',
      initial: true,
      page: SelectedDataSourceScope,
      name: RouteNames.homeFlow,
      transitionsBuilder: TransitionsBuilders.fadeIn,
      children: [
        _homeRoute,
        //
        _settingsRoute,
        //
        _developerToolsRoute,
        //
        _selectDataSourceRoute,
      ],
    ),
    //
    _selectDataSourceRoute,
    //
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
  CustomPage<T> page, {
  Color? barrierColor,
}) {
  return DialogRoute(
    settings: page,
    builder: (context) => child,
    context: context,
    barrierColor: barrierColor,
    // expanded: true,
  );
}
