import 'dart:collection';

import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:pixel_app_flutter/domain/apps/apps.dart';
import 'package:re_seedwork/re_seedwork.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Injectable(as: PinnedAppsStorage)
class PinnedAppsStorageImpl
    extends InMemoryValueStore<UnmodifiableSetView<String>>
    implements PinnedAppsStorage {
  PinnedAppsStorageImpl({required this.prefs})
      : _initialized = false,
        super(UnmodifiableSetView(const {}));

  @protected
  static const kPinnedAppsKey = 'pinnedApps';

  @protected
  final SharedPreferences prefs;

  bool _initialized;

  bool get initialized => _initialized;

  @override
  Future<Result<ErrorReadingPinnedAppsStorage, Set<String>>> read() async {
    if (initialized) return Result.value(data);
    final apps = prefs.getStringList(kPinnedAppsKey);
    if (apps != null) await put(UnmodifiableSetView({...apps}));
    _initialized = true;
    return Result.value(data);
  }

  @override
  Future<Result<ErrorRemovingPinnedAppsStorage, Set<String>>> remove(
    List<String> packageNames,
  ) async {
    if (packageNames.isEmpty) return Result.value(data);

    final updated = UnmodifiableSetView(
      {...data.where((element) => !packageNames.contains(element))},
    );
    final success = await prefs.setStringList(kPinnedAppsKey, [...updated]);
    if (success) {
      await put(updated);
      return Result.value(data);
    }

    return const Result.error(ErrorRemovingPinnedAppsStorage.unknown);
  }

  @override
  Future<Result<ErrorWritingPinnedAppsStorage, Set<String>>> write(
    String packageName,
  ) async {
    final updated = UnmodifiableSetView(
      {...data, packageName},
    );
    final success = await prefs.setStringList(kPinnedAppsKey, [...updated]);

    if (success) {
      await put(updated);
      return Result.value(data);
    }

    return const Result.error(ErrorWritingPinnedAppsStorage.unknown);
  }
}
