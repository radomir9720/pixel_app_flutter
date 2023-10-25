import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:provider/provider.dart';

@RoutePage(name: 'LEDPanelFlow')
class LEDPanelScope extends AutoRouter {
  const LEDPanelScope({super.key});

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      return MultiProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return AddLEDConfigBloc(storage: context.read());
            },
          ),
          BlocProvider(
            create: (context) {
              return RemoveLEDConfigBloc(storage: context.read());
            },
          ),
        ],
        child: content,
      );
    };
  }
}
