import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MainScope extends SingleChildStatelessWidget {
  const MainScope({super.key, required Widget child}) : super(child: child);

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return MultiProvider(
      providers: [
        // blocs
        BlocProvider(
          create: (context) => SelectDataSourceBloc(dataSources: GetIt.I()),
        ),
        BlocProvider(
          create: (context) => DataSourceConnectBloc(
            dataSourceStorage: GetIt.I(),
            availableDataSources: GetIt.I(),
          )..add(const DataSourceConnectEvent.tryConnectWithStorageData()),
        ),
        //
        Provider<Environment>(create: (context) => GetIt.I())
      ],
      child: child,
    );
  }
}
