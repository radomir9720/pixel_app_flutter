import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/led_panel/led_panel.dart';
import 'package:provider/provider.dart';

class GeneralScope extends AutoRouter {
  const GeneralScope({super.key});

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      return MultiProvider(
        providers: [
          BlocProvider(
            create: (context) {
              context
                  .read<OutgoingPackagesCubit>()
                  .subscribeTo({const CustomImageParameterId()});

              return LEDPanelSwitcherCubit(
                dataSource: context.read(),
              );
            },
          ),
        ],
        child: content,
      );
    };
  }
}
