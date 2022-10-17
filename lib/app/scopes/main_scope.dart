import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pixel_app_flutter/bootstrap.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:pixel_app_flutter/domain/settings/settings.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MainScope extends SingleChildStatelessWidget {
  const MainScope({super.key, required Widget child}) : super(child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiProvider(
      providers: [
        Provider<Environment>(create: (context) => GetIt.I()),
        Provider<PackageInfo>(create: (context) => GetIt.I()),
        Provider<List<DataSource>>(create: (context) => GetIt.I()),
        // storages
        Provider<DataSourceStorage>(create: (context) => GetIt.I()),
        // blocs
        BlocProvider(
          create: (context) => SelectDataSourceBloc(
            dataSources: context.read(),
          ),
        ),
        BlocProvider(
          create: (context) => DataSourceConnectBloc(
            dataSourceStorage: context.read(),
            availableDataSources: context.read(),
          )..add(const DataSourceConnectEvent.tryConnectWithStorageData()),
        ),
        BlocProvider(
          create: (context) => AlwaysOnDisplayToggleBloc(
            service: GetIt.I(),
            storage: GetIt.I(),
          )..add(const AlwaysOnDisplayToggleEvent.init()),
          lazy: false,
        ),
      ],
      child: child,
    );
  }
}
