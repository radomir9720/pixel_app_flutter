import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/data/services/bluetooth_data_source.dart';
import 'package:pixel_app_flutter/data/services/demo_data_source.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:provider/provider.dart';

class SelectDataSourceScope extends AutoRouter {
  const SelectDataSourceScope({super.key});

  @override
  AutoRouterState createState() => _AutoRouteState();

  @override
  Widget Function(BuildContext context, Widget content)? get builder {
    return (context, content) {
      return MultiProvider(
        providers: [
          BlocProvider(
            create: (context) => SelectDataSourceBloc(
              dataSources: context.read(),
            ),
          ),
          BlocProvider(
            create: (context) {
              final bloc = DataSourceConnectBloc(
                dataSourceStorage: context.read(),
                availableDataSources: context.read(),
              );
              final isInitial = context.read<DataSourceCubit>().state.isInitial;
              if (isInitial) {
                bloc.add(
                  const DataSourceConnectEvent.tryConnectWithStorageData(),
                );
              }

              return bloc;
            },
            lazy: false,
          ),
        ],
        child: content,
      );
    };
  }
}

class _AutoRouteState extends AutoRouterState {
  @protected
  late final List<DataSource> dataSources;

  @protected
  final id = DateTime.now().millisecondsSinceEpoch;

  late final DataSourceCubit dataSourceCubit;

  @override
  void initState() {
    dataSourceCubit = context.read<DataSourceCubit>();
    final devToolsParamsStorage =
        context.read<DeveloperToolsParametersStorage>();
    final env = context.read<Environment>();
    dataSources = [
      if (env.isDev)
        BluetoothDataSource(
          bluetoothSerial: GetIt.I(),
          id: id,
        ),
      DemoDataSource(
        generateRandomErrors: () {
          return env.isDev &&
              devToolsParamsStorage
                  .data.enableRandomErrorGenerationForDemoDataSource;
        },
        updatePeriodMillis: () {
          return devToolsParamsStorage.data.requestsPeriodInMillis;
        },
        id: id,
      ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    final selected = dataSourceCubit.state.ds
        .when(undefined: () => null, presented: (p) => p.dataSource);
    final selectedUniqieId = '${selected?.key}_${selected?.id}';
    for (final ds in dataSources) {
      final dsUniqueId = '${ds.key}_${ds.id}';
      if (dsUniqueId != selectedUniqieId) {
        ds.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<List<DataSource>>.value(
      value: dataSources,
      builder: (context, child) {
        return super.build(context);
      },
    );
  }
}
