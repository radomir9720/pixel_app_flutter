import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_app_flutter/presentation/screens/general/general_screen.dart';

class GeneralScreenWrapper extends StatelessWidget with AutoRouteWrapper {
  const GeneralScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const GeneralScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
