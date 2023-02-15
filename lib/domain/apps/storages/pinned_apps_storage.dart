import 'dart:collection';

import 'package:re_seedwork/re_seedwork.dart';

abstract class PinnedAppsStorage
    extends ValueStore<UnmodifiableSetView<String>> {
  Future<Result<ErrorWritingPinnedAppsStorage, Set<String>>> write(
    String packageName,
  );

  Future<Result<ErrorRemovingPinnedAppsStorage, Set<String>>> remove(
    List<String> packageNames,
  );

  Future<Result<ErrorReadingPinnedAppsStorage, Set<String>>> read();
}

enum ErrorWritingPinnedAppsStorage { unknown, packageNameIsNull }

enum ErrorRemovingPinnedAppsStorage { unknown, packageNameIsNull }

enum ErrorReadingPinnedAppsStorage { unknown }
