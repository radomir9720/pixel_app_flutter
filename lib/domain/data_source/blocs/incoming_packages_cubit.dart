import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

class IncomingPackagesCubit extends Cubit<DataSourceIncomingPackage?>
    with ConsumerBlocMixin {
  IncomingPackagesCubit(this.dataSource) : super(null) {
    subscribe(dataSource.packageStream, emit);
  }

  @protected
  final DataSource dataSource;
}
