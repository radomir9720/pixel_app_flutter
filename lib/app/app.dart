import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/app/colors.dart';
import 'package:pixel_app_flutter/presentation/app/theme.dart';
import 'package:pixel_app_flutter/presentation/app/typography.dart';
import 'package:pixel_app_flutter/presentation/routes/main_router.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/organisms/screen_data.dart';

class App extends StatefulWidget {
  const App({super.key, this.observersBuilder});

  @protected
  final List<NavigatorObserver> Function()? observersBuilder;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final _appRouter = MainRouter();

  @override
  Widget build(BuildContext context) {
    return AppColors(
      data: const AppColorsData.dark(),
      child: BlocBuilder<DataSourceConnectBloc, DataSourceConnectState>(
        buildWhen: (previous, current) {
          return !current.isLoading || previous.isInitial;
        },
        builder: (context, state) {
          return MaterialApp.router(
            theme: MaterialTheme.from(AppColors.of(context)),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routeInformationParser: _appRouter.defaultRouteParser(),
            routerDelegate: AutoRouterDelegate.declarative(
              _appRouter,
              routes: (_) {
                if (state.payload.isPresent) {
                  return [
                    HomeFlow(
                      children: [
                        const HomeRoute(),
                        if (state.isFailure) ...[
                          const SettingsRoute(),
                          const SelectDataSourceFlow(),
                        ]
                      ],
                    ),
                  ];
                }

                if (state.isLoading) return [const LoadingRoute()];

                return const [SelectDataSourceFlow()];
              },
              navigatorObservers: widget.observersBuilder ??
                  AutoRouterDelegate.defaultNavigatorObserversBuilder,
            ),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: AppTypography(
                  child: Screen(
                    child: AnnotatedRegion<SystemUiOverlayStyle>(
                      value: SystemUiOverlayStyle(
                        statusBarBrightness: Theme.of(context).brightness,
                      ),
                      child: child ?? const SizedBox.shrink(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
