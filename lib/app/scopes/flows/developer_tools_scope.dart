import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/domain/developer_tools/developer_tools.dart';

@RoutePage(name: 'DeveloperToolsFlow')
class DeveloperToolsScope extends AutoRouter {
  const DeveloperToolsScope({super.key});

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DeveloperToolsParametersCubit(
              developerToolsParametersStorage: context.read(),
            ),
          ),
          BlocProvider(
            create: (context) => PauseLogsUpdatingCubit(),
          ),
        ],
        child: content,
      );
    };
  }
}
