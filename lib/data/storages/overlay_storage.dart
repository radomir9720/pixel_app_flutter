import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: OverlayStorage)
final class OverlayStorageImpl implements OverlayStorage {
  const OverlayStorageImpl({required this.prefs});

  @protected
  final SharedPreferences prefs;

  @visibleForTesting
  static const kEnabledKey = 'overlayEnabled';

  @override
  Future<Result<ReadEnabledStorageError, bool?>> readEnabled() async {
    final value = prefs.getBool(kEnabledKey);
    return Result.value(value);
  }

  @override
  Future<Result<SetEnabledStorageError, void>> setEnabled({
    required bool value,
  }) async {
    final success = await prefs.setBool(kEnabledKey, value);
    if (success) return const Result.value(null);

    return const Result.error(SetEnabledStorageError.unknown());
  }
}
