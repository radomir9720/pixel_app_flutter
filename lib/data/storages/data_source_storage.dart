import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: DataSourceStorage)
class DataSourceStorageImpl implements DataSourceStorage {
  DataSourceStorageImpl({required this.preferences});

  final SharedPreferences preferences;

  @protected
  static const kDataSourceKey = 'dataSource';

  @override
  Future<Result<RemoveError, void>> remove() async {
    if (await preferences.remove(kDataSourceKey)) {
      return const Result.value(null);
    }

    return const Result.error(RemoveError.unknown);
  }

  @override
  Future<Result<WriteError, void>> write({
    required String dataSourceKey,
    required String address,
  }) async {
    if (await preferences.setStringList(kDataSourceKey, [
      dataSourceKey,
      address,
    ])) {
      return const Result.value(null);
    }

    return const Result.error(WriteError.unknown);
  }

  @override
  Result<ReadError, List<String>> read() {
    final value = preferences.getStringList(kDataSourceKey);
    if (value == null) return const Result.error(ReadError.noValue);

    return Result.value(value);
  }
}
