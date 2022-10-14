import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';

class DeveloperToolsScope extends AutoRouter {
  const DeveloperToolsScope({super.key});

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DeveloperToolsParametersCubit(
              developerToolsParametersStorage: GetIt.I(),
            ),
          ),
        ],
        child: content,
      );
    };
  }
}
