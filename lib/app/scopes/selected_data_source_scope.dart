import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:provider/provider.dart';

class SelectedDataSourceScope extends AutoRouter {
  const SelectedDataSourceScope({super.key});

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      final device = context.watch<DataSourceConnectBloc>().state.payload.when(
            presented: (d) => d,
            undefined: () {
              throw Exception('At this step data source must be selected');
            },
          );

      return MultiProvider(
        providers: [
          // storages
          InheritedProvider<DeveloperToolsParametersStorage>(
            create: (context) => GetIt.I(),
          ),
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
                final dataSources = context.read<List<DataSource>>();
                for (final ds in dataSources) {
                  ds.addObserver(cubit.add);
                }
                return cubit;
              },
              lazy: false,
            ),
          ]
        ],
        child: content,
      );
    };
  }
}
