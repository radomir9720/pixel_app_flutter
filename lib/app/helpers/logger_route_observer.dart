import 'package:flutter/material.dart';

class LoggerRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  LoggerRouteObserver({
    this.onNewScreen,
    this.routeFilter = defaultRouteFilter,
    this.nameExtractor = defaultNameExtractor,
  });

  @protected
  final ValueSetter<String?>? onNewScreen;

  @protected
  final bool Function(Route<dynamic>? route) routeFilter;

  @protected
  final String? Function(RouteSettings settings) nameExtractor;

  static String? defaultNameExtractor(RouteSettings settings) => settings.name;

  static bool defaultRouteFilter(Route<dynamic>? route) =>
      route is PageRoute || route is DialogRoute;

  void _logScreen(Route<dynamic> route) {
    final screenName = nameExtractor(route.settings);
    onNewScreen?.call(screenName);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (routeFilter(route)) {
      _logScreen(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && routeFilter(newRoute)) {
      _logScreen(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null &&
        routeFilter(previousRoute) &&
        routeFilter(route)) {
      _logScreen(previousRoute);
    }
  }
}
