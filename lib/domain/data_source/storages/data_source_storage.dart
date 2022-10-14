import 'package:re_seedwork/re_seedwork.dart';

abstract class DataSourceStorage {
  const DataSourceStorage();

  Future<Result<DataSourceStorageWriteError, void>> write({
    required String dataSourceKey,
    required String address,
  });

  Future<Result<DataSourceStorageRemoveError, void>> remove();

  Result<DataSourceStorageReadError, List<String>> read();
}

enum DataSourceStorageWriteError { unknown }

enum DataSourceStorageRemoveError { unknown }

enum DataSourceStorageReadError { unknown, noValue }
