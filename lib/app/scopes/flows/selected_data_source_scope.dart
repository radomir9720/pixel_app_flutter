import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
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
      return BlocConsumer<DataSourceCubit, DataSourceState>(
        listenWhen: (previous, current) {
          final previousNullable = previous.ds.when(
            undefined: () {},
            presented: (p) => p,
          );

          final currentNullable = current.ds.when(
            undefined: () {},
            presented: (p) => p,
          );

          if (previousNullable != null && currentNullable != null) {
            if (previousNullable.dataSource.id !=
                    currentNullable.dataSource.id ||
                previousNullable.dataSource.key !=
                    currentNullable.dataSource.key ||
                previousNullable.address != currentNullable.address) {
              previousNullable.dataSource.dispose();
            }
          }
          return false;
        },
        listener: (context, state) {},
        builder: (context, state) {
          final dswa = state.ds.when(
            presented: (d) => d,
            undefined: () => null,
          );

          if (dswa == null) {
            return GradientScaffold(body: const SizedBox.shrink());
          }

          return MultiProvider(
            providers: [
              Provider<DataSource>.value(
                key: ValueKey('ds_${dswa.dataSource.key}_${dswa.address}'),
                value: dswa.dataSource,
              ),

              // blocs
              BlocProvider(
                key: ValueKey('cs_${dswa.dataSource.key}_${dswa.address}'),
                create: (context) {
                  if (context.read<Environment>().isDev) {
                    context.read<DataSource>().addObserver(
                      (raw, parsed, direction) {
                        if (raw != null) {
                          context.read<RawRequestsExchangeLogsCubit>().add(
                                raw,
                                direction,
                              );
                          if (parsed != null) {
                            context
                                .read<ProcessedRequestsExchangeLogsCubit>()
                                .add(parsed, direction);
                          }
                        }
                      },
                    );
                  }

                  return DataSourceConnectionStatusCubit(
                    dataSource: dswa.dataSource,
                    dataSourceStorage: context.read(),
                    developerToolsParametersStorage: context.read(),
                    loggers: [
                      if (context.read<Environment>().isDev)
                        (outgoing) => context
                            .read<ProcessedRequestsExchangeLogsCubit>()
                            .add(
                              outgoing,
                              DataSourceRequestDirection.outgoing,
                            )
                    ],
                  )..initHandshake();
                },
                lazy: false,
              ),
              BlocProvider(
                create: (context) => OutgoingPackagesCubit(
                  dataSource: context.read(),
                  developerToolsParametersStorage: context.read(),
                  loggers: [
                    if (context.read<Environment>().isDev)
                      (outgoing) => context
                          .read<ProcessedRequestsExchangeLogsCubit>()
                          .add(
                            outgoing,
                            DataSourceRequestDirection.outgoing,
                          )
                  ],
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
                  ..subscribeToTurnSignals(),
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
