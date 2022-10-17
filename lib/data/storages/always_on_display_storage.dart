import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/settings/settings.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: AlwaysOnDisplayStorage)
class AlwaysOnDisplayStorageImpl implements AlwaysOnDisplayStorage {
  AlwaysOnDisplayStorageImpl({required this.preferences});

  @protected
  final SharedPreferences preferences;

  @visibleForTesting
  static const kEnableAlwaysOnDisplay = 'EnableAlwaysOnDisplay';

  @override
  Result<AlwaysOnDisplayStorageReadError, bool> read() {
    final value = preferences.getBool(kEnableAlwaysOnDisplay);
    if (value == null) {
      return const Result.error(AlwaysOnDisplayStorageReadError.noValue);
    }

    return Result.value(value);
  }

  @override
  Future<Result<AlwaysOnDisplayStorageRemoveError, void>> remove() async {
    final success = await preferences.remove(kEnableAlwaysOnDisplay);
    if (success) return const Result.value(null);
    return const Result.error(AlwaysOnDisplayStorageRemoveError.unknown);
  }

  @override
  Future<Result<AlwaysOnDisplayStorageWriteError, void>> write({
    required bool enable,
  }) async {
    final success = await preferences.setBool(kEnableAlwaysOnDisplay, enable);
    if (success) return const Result.value(null);
    return const Result.error(AlwaysOnDisplayStorageWriteError.unknown);
  }
}
