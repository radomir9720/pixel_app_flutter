import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/l10n/l10n.dart';
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
          final prev = previous.ds
              .when(undefined: () {}, presented: (p) => p.dataSource);
          final curr =
              current.ds.when(undefined: () {}, presented: (p) => p.dataSource);
          if (prev != null && curr != null) {
            if (prev.id != curr.id && prev.key != curr.key) {
              prev.dispose();
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
              // blocs
              BlocProvider(
                key: ValueKey('cs_${dswa.dataSource.key}_${dswa.address}'),
                create: (context) => DataSourceConnectionStatusCubit(
                  dataSource: dswa.dataSource,
                  dataSourceStorage: context.read(),
                ),
                lazy: false,
              ),
              BlocProvider(
                key: ValueKey('dsl_${dswa.dataSource.key}_${dswa.address}'),
                create: (context) => DataSourceLiveCubit(
                  dataSource: dswa.dataSource,
                  developerToolsParametersStorage: context.read(),
                  onHandshakeTimeout: context
                      .read<DataSourceConnectionStatusCubit>()
                      .registerHandshakeTimeoutError,
                  onSuccessfulHandshake: (cubit) {
                    cubit.initParametersSubscription();
                  },
                )..initHandshake(),
              ),
              if (context.watch<Environment>().isDev) ...[
                BlocProvider(
                  create: (context) {
                    final cubit = ProcessedRequestsExchangeLogsCubit();
                    context.read<DataSourceLiveCubit>().addObserver(cubit.add);
                    return cubit;
                  },
                  lazy: false,
                ),
                BlocProvider(
                  create: (context) {
                    final cubit = RawRequestsExchangeLogsCubit();
                    context.read<DataSourceCubit>().state.ds.when(
                          undefined: () {},
                          presented: (ds) {
                            ds.dataSource.addObserver(cubit.add);
                          },
                        );
                    return cubit;
                  },
                  lazy: false,
                ),
              ],
            ],
            child: BlocListener<DataSourceConnectionStatusCubit,
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
              child: content,
            ),
          );
        },
      );
    };
  }
}
