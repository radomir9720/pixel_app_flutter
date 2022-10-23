import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';

abstract class DataSourceStorage
    extends ValueStore<Optional<DataSourceWithAddress>> {
  DataSourceStorage();

  Future<Result<DataSourceStorageWriteError, void>> write(
    DataSourceWithAddress dataSourceWithAddress,
  );

  Future<Result<DataSourceStorageRemoveError, void>> remove();

  Result<DataSourceStorageReadError, List<String>> read();
}

enum DataSourceStorageWriteError { unknown }

enum DataSourceStorageRemoveError { unknown }

enum DataSourceStorageReadError { unknown, noValue }
