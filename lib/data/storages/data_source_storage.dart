import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/data_source/data_source.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: DataSourceStorage)
class DataSourceStorageImpl
    extends InMemoryValueStore<Optional<DataSourceWithAddress>>
    implements DataSourceStorage {
  DataSourceStorageImpl({required this.preferences})
      : super(const Optional.undefined());

  @protected
  final SharedPreferences preferences;

  @protected
  static const kDataSourceKey = 'dataSource';

  @override
  Future<Result<DataSourceStorageRemoveError, void>> remove() async {
    if (await preferences.remove(kDataSourceKey)) {
      return const Result.value(null);
    }

    await put(const Optional.undefined());

    return const Result.error(DataSourceStorageRemoveError.unknown);
  }

  @override
  Future<Result<DataSourceStorageWriteError, void>> write(
    DataSourceWithAddress dataSourceWithAddress,
  ) async {
    if (await preferences.setStringList(kDataSourceKey, [
      dataSourceWithAddress.dataSource.key,
      dataSourceWithAddress.address,
    ])) {
      await put(Optional.presented(dataSourceWithAddress));
      return const Result.value(null);
    }

    return const Result.error(DataSourceStorageWriteError.unknown);
  }

  @override
  Result<DataSourceStorageReadError, List<String>> read() {
    final value = preferences.getStringList(kDataSourceKey);
    if (value == null) {
      put(const Optional.undefined());
      return const Result.error(DataSourceStorageReadError.noValue);
    }

    return Result.value(value);
  }
}
