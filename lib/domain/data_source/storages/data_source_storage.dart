import 'package:re_seedwork/re_seedwork.dart';

abstract class DataSourceStorage {
  Future<Result<WriteError, void>> write({
    required String dataSourceKey,
    required String address,
  });

  Future<Result<RemoveError, void>> remove();

  Result<ReadError, List<String>> read();
}

enum WriteError { unknown }

enum RemoveError { unknown }

enum ReadError { unknown, noValue }
