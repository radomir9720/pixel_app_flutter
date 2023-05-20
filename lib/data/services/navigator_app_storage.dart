import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: NavigatorAppStorage)
final class NavigatorAppStorageImpl implements NavigatorAppStorage {
  const NavigatorAppStorageImpl({required this.prefs});

  @protected
  final SharedPreferences prefs;

  @visibleForTesting
  static const kFastAccessKey = 'fastAccessKey';

  @visibleForTesting
  static const kNavigatorAppKey = 'navigatorAppKey';

  @override
  Future<Result<GetFastAccessNavigatorAppStorageError, bool?>>
      getFastAccess() async {
    final value = prefs.getBool(kFastAccessKey);
    return Result.value(value);
  }

  @override
  Future<Result<ReadNavigatorAppStorageError, String?>> read() async {
    final value = prefs.getString(kNavigatorAppKey);
    return Result.value(value);
  }

  @override
  Future<Result<SaveNavigatorAppStorageError, void>> save(
    String package,
  ) async {
    final success = await prefs.setString(kNavigatorAppKey, package);
    if (success) return const Result.value(null);

    return const Result.error(SaveNavigatorAppStorageError.unknown());
  }

  @override
  Future<Result<SetFastAccessNavigatorAppStorageError, void>> setFastAccess({
    required bool value,
  }) async {
    final success = await prefs.setBool(kFastAccessKey, value);
    if (success) return const Result.value(null);

    return const Result.error(SetFastAccessNavigatorAppStorageError.unknown());
  }
}
