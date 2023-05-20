import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:provider/provider.dart';

class AppsScope extends AutoRouter {
  const AppsScope({super.key});

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      return MultiProvider(
        providers: [
          // storages
          InheritedProvider<PinnedAppsStorage>(
            create: (context) => GetIt.I()..read(),
            lazy: false,
          ),

          // blocs
          BlocProvider(
            create: (context) => GetAppsListBloc(
              appsService: context.read(),
              pinnedAppsStorage: context.read(),
            )..add(const GetAppsListEvent.loadAppsList()),
          ),

          BlocProvider(
            create: (context) => ManagePinnedAppsBloc(
              pinnedAppsStorage: context.read(),
            ),
          ),
        ],
        child: content,
      );
    };
  }
}
