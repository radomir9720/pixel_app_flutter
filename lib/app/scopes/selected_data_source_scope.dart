import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:provider/provider.dart';

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
          final device = state.ds.when(
            presented: (d) => d,
            undefined: () {
              throw Exception('At this step data source must be selected');
            },
          );

          return MultiProvider(
            providers: [
              // blocs
              BlocProvider(
                key: ValueKey('${device.dataSource.key}_${device.address}'),
                create: (context) => DataSourceLiveCubit(
                  dataSource: device.dataSource,
                  developerToolsParametersStorage: context.read(),
                )..initialHandshake(),
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
              ]
            ],
            child: content,
          );
        },
      );
    };
  }
}
