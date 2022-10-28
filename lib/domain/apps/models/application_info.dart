import 'dart:typed_data';

import 'package:meta/meta.dart';

@immutable
class ApplicationInfo {
  const ApplicationInfo({
    this.name,
    this.icon,
    this.packageName,
    this.versionName,
    this.versionCode,
  });

  final String? name;
  final Uint8List? icon;
  final String? packageName;
  final String? versionName;
  final int? versionCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApplicationInfo &&
        other.name == name &&
        other.icon == icon &&
        other.packageName == packageName &&
        other.versionName == versionName &&
        other.versionCode == versionCode;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        icon.hashCode ^
        packageName.hashCode ^
        versionName.hashCode ^
        versionCode.hashCode;
  }
}
