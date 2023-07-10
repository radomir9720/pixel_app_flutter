import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/domain/app/storages/logger_storage.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/developer_tools/developer_tools.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
import 'package:pixel_app_flutter/presentation/screens/common/loading_screen.dart';
import 'package:pixel_app_flutter/presentation/widgets/app/atoms/gradient_scaffold.dart';
import 'package:provider/provider.dart';
import 'package:re_widgets/re_widgets.dart';

class SelectedDataSourceScope extends AutoRouter {
  const SelectedDataSourceScope({super.key});

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      return BlocBuilder<DataSourceCubit, DataSourceState>(
        builder: (context, state) {
          final dswa = state.ds.when(
            presented: (d) => d,
            undefined: () => null,
          );

          if (dswa == null) {
            return GradientScaffold(body: const SizedBox.shrink());
          }

          return MultiProvider(
            key: ValueKey('${dswa.dataSource.key}_${dswa.address}'),
            providers: [
              Provider<DataSource>.value(value: dswa.dataSource),
              Provider<AppsService>(create: (context) => GetIt.I()),

              // storages
              Provider<NavigatorAppStorage>(create: (context) => GetIt.I()),

              // blocs
              BlocProvider<DataSourceConnectionStatusCubit>(
                create: (context) {
                  if (context.read<Environment>().isDev) {
                    context.read<DataSource>().addObserver(
                      (observable) {
                        observable.whenOrNull(
                          incomingPackage: (package) {
                            context
                                .read<ProcessedRequestsExchangeLogsCubit>()
                                .add(
                                  package,
                                  DataSourceRequestDirection.incoming,
                                );
                            context.read<LoggerStorage>().logInfo(
                                  package.toString(),
                                  'IncomingProcessedPackage',
                                );
                          },
                          outgoingPackage: (package) {
                            context
                                .read<ProcessedRequestsExchangeLogsCubit>()
                                .add(
                                  package,
                                  DataSourceRequestDirection.outgoing,
                                );
                            context.read<ExchangeConsoleLogsCubit>().addParsed(
                                  package,
                                  DataSourceRequestDirection.outgoing,
                                );
                            context.read<LoggerStorage>().logInfo(
                                  package.toString(),
                                  'OutgoingPackage',
                                );
                          },
                          rawIncomingBytes: (bytes) {
                            context.read<RawRequestsExchangeLogsCubit>().add(
                                  bytes,
                                  DataSourceRequestDirection.incoming,
                                );
                            context.read<LoggerStorage>().logInfo(
                                  bytes.toString(),
                                  'IncomingRawBytes',
                                );
                          },
                          rawIncomingPackage: (bytes) {
                            context.read<ExchangeConsoleLogsCubit>().addRaw(
                                  bytes,
                                  DataSourceRequestDirection.incoming,
                                );
                            context.read<LoggerStorage>().logInfo(
                                  bytes.toString(),
                                  'IncomingRawPackage',
                                );
                          },
                        );
                      },
                    );
                  }

                  return DataSourceConnectionStatusCubit(
                    dataSource: dswa.dataSource,
                    dataSourceStorage: context.read(),
                    developerToolsParametersStorage: context.read(),
                  )..initHandshake();
                },
                lazy: false,
              ),
              BlocProvider(
                create: (context) => OutgoingPackagesCubit(
                  dataSource: context.read(),
                  developerToolsParametersStorage: context.read(),
                ),
              ),

              BlocProvider(
                create: (context) => LightsCubit(
                  dataSource: context.read(),
                )
                  ..subscribeToSideBeam()
                  ..subscribeToHazardBeam()
                  ..subscribeToHighBeam()
                  ..subscribeToLowBeam()
                  ..subscribeToTurnSignals()
                  ..subscribeToReverseLight()
                  ..subscribeToBrakeLight(),
                lazy: false,
              ),
              BlocProvider(
                create: (context) {
                  context.read<OutgoingPackagesCubit>().subscribeTo(
                        GeneralDataCubit.kDefaultSubscribeParameters,
                      );
                  return GeneralDataCubit(
                    dataSource: context.read(),
                  );
                },
              ),
              BlocProvider(
                create: (context) =>
                    LaunchAppCubit(appsService: context.read()),
              ),
              BlocProvider(
                create: (context) => NavigatorAppBloc(storage: context.read())
                  ..add(const NavigatorAppEvent.load()),
                lazy: false,
              ),
              BlocProvider(
                create: (context) => NavigatorFastAccessBloc(
                  storage: context.read(),
                )..add(const NavigatorFastAccessEvent.load()),
                lazy: false,
              ),
            ],
            child: BlocConsumer<DataSourceConnectionStatusCubit,
                DataSourceConnectionStatus>(
              listener: (context, state) {
                final error = state.maybeWhen(
                  orElse: () => null,
                  lost: () => context.l10n.dataSourceConnectionLostMessage,
                  notEstablished: () =>
                      context.l10n.failedToConnectToDataSourceMessage,
                  handshakeTimeout: () =>
                      context.l10n.failedToConnectToDataSourceMessage,
                );
                if (error != null) context.showSnackBar(error);
              },
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => const LoadingScreen(),
                  connected: () => content,
                );
              },
            ),
          );
        },
      );
    };
  }
}
